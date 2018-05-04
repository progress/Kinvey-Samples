import { AuthGuard } from "./shared/auth-guard.service";

export const authProviders = [
  AuthGuard
];

export const appRoutes = [
    { path: "", redirectTo: "/login", pathMatch: "full" },
    { path: "home", loadChildren: "./home/home.module#HomeModule" },
    { path: "login", loadChildren: "./login/login.module#LoginModule" }
];
