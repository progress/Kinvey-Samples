import { Component, OnInit } from "@angular/core";
import { KinveyService } from "../shared/kinvey.service";
import { Router } from "@angular/router";
import { User } from "../shared/user.model";
import { LoginService } from "../shared/login.service";
import { Kinvey } from "kinvey-nativescript-sdk";
import { Push } from "kinvey-nativescript-sdk";
import { Config } from "../shared/config";

@Component({
    selector: "Home",
    moduleId: module.id,
    templateUrl: "./home.component.html",
    providers: [LoginService, User]
})
export class HomeComponent implements OnInit {
    private username: string;

    constructor(private router: Router, private userService: LoginService) {
        if (!!Kinvey.User.getActiveUser()) {
            this.username = Kinvey.User.getActiveUser().username;
        } else {
            this.username = "<Unknown>";
        }
    }

    ngOnInit(): void {
    }

    submit() {
        Push.unregister()
        .then(() => {                
            console.log("Unregistered from Firebase");
            KinveyService.token = "";
            this.userService.logoff();
            console.log("User has been logged out!");
        })
        .catch((error: Error) => {                
            this.userService.logoff();
            console.log(error.stack);
            this.userService.handleError("User has been logout. However, the device token could not be unregistered from Firebase", error);
        });
        this.router.navigate([""]);
    }
}
