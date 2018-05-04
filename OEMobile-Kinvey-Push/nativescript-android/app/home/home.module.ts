import { HttpClientModule } from "@angular/common/http";
import { NgModule, NgModuleFactoryLoader, NO_ERRORS_SCHEMA } from "@angular/core";
import { CookieXSRFStrategy, HttpModule, XSRFStrategy } from "@angular/http";
import { nsXSRFStrategyFactory } from "nativescript-angular/http";
import { NativeScriptCommonModule } from "nativescript-angular/common";

import { HomeRoutingModule } from "./home-routing.module";
import { HomeComponent } from "./home.component";

@NgModule({
    imports: [
        HttpModule,
        NativeScriptCommonModule,
        HomeRoutingModule
    ],
    declarations: [
        HomeComponent
    ],
    providers: [
        HttpClientModule,
        {
            provide: XSRFStrategy,
            useFactory: nsXSRFStrategyFactory
        }
    ],
    schemas: [
        NO_ERRORS_SCHEMA
    ]
})
export class HomeModule { }
