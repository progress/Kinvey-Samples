import { Component, ElementRef, OnInit, ViewChild } from "@angular/core";
import { Router } from "@angular/router";
import { Color } from "color";
import { connectionType, getConnectionType } from "connectivity";
import { Animation } from "ui/animation";
import { View } from "ui/core/view";
import { prompt } from "ui/dialogs";
import { Page } from "ui/page";
import { TextField } from "ui/text-field";

import { User } from "../shared/user.model";
import { LoginService } from "../shared/login.service";
import { KinveyService } from "../shared/kinvey.service";


@Component({
  selector: "gr-login",
  moduleId: module.id,
  templateUrl: "./login.component.html",
  styleUrls: ["./login-common.css", "./login.component.css"],
})
export class LoginComponent implements OnInit {
  user: User;
  isLoggingIn = true;
  isAuthenticating = false;

  @ViewChild("mainContainer") mainContainer: ElementRef;
  @ViewChild("formControls") formControls: ElementRef;
  @ViewChild("password") password: ElementRef;

  constructor(private router: Router,
    private userService: LoginService,
    private page: Page) {
    this.user = new User();
  }

  ngOnInit() {
    this.page.actionBarHidden = true;
  }

  focusPassword() {
    this.password.nativeElement.focus();
  }

  submit() {
    this.isAuthenticating = true;    
    this.login();
  }

  login() {
    const loginPromise = this.userService.login(this.user);
    if ( loginPromise === null ) {
      this.isAuthenticating = false;
      this.router.navigate(["/home"]);
      this.userService.register().then((deviceToken: string) => {
        console.log("Registered the device");
        KinveyService.token = deviceToken;
        this.userService.onNotification();
      })
      .catch((error: Error) => {
        console.log("Error while registering in Firebase : " + error);
      })          
    }
    else {
    loginPromise
      .then(
        () => {
          this.isAuthenticating = false;
          this.router.navigate(["/home"]);
          this.userService.register().then((deviceToken: string) => {
            console.log("Registered the device");
            KinveyService.token = deviceToken;
            this.userService.onNotification();
          })
          .catch((error: Error) => {
            console.log("Error while registering in Firebase : " + error);
          })          
        },
        (error) => {
          alert("Unfortunately we could not find your account.");
          this.isAuthenticating = false;
        }
      );
    }  
  }

}
