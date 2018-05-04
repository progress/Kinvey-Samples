import { ModuleWithProviders }  from "@angular/core";
import { Routes, RouterModule } from "@angular/router";

import { LoginComponent } from "./login.component";
import { HomeComponent } from "../home/home.component";

const loginRoutes: Routes = [
  { path: "home", component: HomeComponent },
];
export const loginRouting: ModuleWithProviders = RouterModule.forChild(loginRoutes);