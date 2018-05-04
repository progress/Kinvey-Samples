import { Injectable } from "@angular/core";
import { Router, CanActivate } from "@angular/router";

import { KinveyService } from "./kinvey.service";

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private router: Router) { }

  canActivate() {
    if (KinveyService.isLoggedIn()) {
      return true;
    }
    else {
      this.router.navigate(["/login"]);
      return false;
    }
  }
}

