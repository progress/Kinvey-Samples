import { NativeScriptModule } from "nativescript-angular/nativescript.module";
import { NgModule, NO_ERRORS_SCHEMA } from "@angular/core";
import { NativeScriptHttpModule } from "nativescript-angular/http";
import { NativeScriptRouterModule } from "nativescript-angular/router";

import { authProviders,appRoutes } from "./app-routing.module";
import { AppComponent } from "./app.component";
import { KinveyService } from "./shared/kinvey.service";
import { LoginService } from "./shared/login.service";

import { LoginModule } from "./login/login.module";
import { HomeModule } from "./home/home.module";

@NgModule({
    bootstrap: [
        AppComponent
    ],
    imports: [
        NativeScriptModule,
        NativeScriptHttpModule,
        NativeScriptRouterModule,
        NativeScriptRouterModule.forRoot(appRoutes),
        LoginModule,
        HomeModule
    ],
    declarations: [
        AppComponent
    ],
    providers: [
        KinveyService,
        LoginService,
        authProviders
    ],
    schemas: [
        NO_ERRORS_SCHEMA
    ]
})
export class AppModule { }
