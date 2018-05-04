import { Injectable } from "@angular/core";
import { Observable } from "rxjs/Observable";
import "rxjs/add/operator/do";
import "rxjs/add/operator/map";
import "rxjs/add/observable/throw";
import "rxjs/add/operator/catch";
import { Kinvey } from "kinvey-nativescript-sdk";
import { Push } from "kinvey-nativescript-sdk";
import { Headers, Http, RequestOptions, Response } from "@angular/http";
import { Config } from "./config";
import * as dialogs from "ui/dialogs";
import { HomeModule } from "../home/home.module";

import { User } from "./user.model";
import { KinveyService } from "./kinvey.service";

@Injectable()
export class LoginService {
  private user: User;
  private promise: Promise<Kinvey.User>;

  constructor(private http: Http) { 
    this.user = new User();
  }

  private notificationData;

  register() : Promise<any> {
      const promise = Push.register({
          android: {
              senderID: Config.senderId
          },
          ios: {
              alert: true,
              badge: true,
              sound: true
          }
      })
      return promise;
  }

  onNotification(): any { 
        Push.onNotification((data: any) => {
            if ( typeof data === "string" ) {
                this.notificationData = JSON.parse(data);
            } else {
                this.notificationData = data;
            }
            const notificationMessage = JSON.parse(this.notificationData.msg);
            dialogs.alert({
                title: notificationMessage.title,
                message: notificationMessage.body,
                okButtonText: "Close"
            }).then(() => {
                console.log("Dialog closed!");
            })
            .catch((error: Error) => {
                this.handleError(error.message, error);
            });          
        });
  }

handleErrorPromise(error: Response | any) {
      console.log("Error: " + error.message || error);

      return Promise.reject(error.message || error);
  }

  public handleError(userMessage: string, error: Error) {
      console.log(userMessage + " : " + error);
      console.log(error.stack);
      console.log(error.message);
  }

  login(user: User): Promise<any> {
    if (this.hasActiveUser()) {
        return null;
    }    
    const promise = Kinvey.User.login(user.username, user.password).then((user: Kinvey.User) => {
        console.log("User logged in successfully");
    })
    .catch((error: Kinvey.BaseError) => { this.handleError(error.message, error); });
    return promise;
  }

  hasActiveUser() : boolean {
      const isActive : boolean = !!Kinvey.User.getActiveUser(); 
      return isActive;
  }

  logoff() {
    Kinvey.User.logout().catch((error: Kinvey.BaseError) => {
        this.handleError(error.message, error);
    })
    KinveyService.token = "";
  }

  handleErrors(error: Response) {
    return Observable.throw(error);
  }
}
