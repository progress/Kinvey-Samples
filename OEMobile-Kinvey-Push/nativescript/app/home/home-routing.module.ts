import { NgModule } from "@angular/core";
import { Routes } from "@angular/router";
import { NativeScriptRouterModule } from "nativescript-angular/router";
import { AuthGuard } from "../shared/auth-guard.service";
import { HomeComponent } from "./home.component";
import { LoginComponent } from "../login/login.component";

const routes: Routes = [
    { path: "login", component: LoginComponent }
];

@NgModule({
    imports: [NativeScriptRouterModule.forChild(routes)],
    exports: [NativeScriptRouterModule]
})
export class HomeRoutingModule { }
