import BaseController from './controller.js'

class LoginCtrl extends BaseController {
    constructor($scope, $injector, $sanitize, provider, jsdoSessions, $kinvey) {
        super($scope, $injector, $sanitize, provider, jsdoSessions, $kinvey);

        
    }

    // Fired when custom html section is loaded
    includeContentLoaded() {

    }

    // Fired when custom html section loading failed
    includeContentError(e) {

    }

    // Fired when view content is loaded
    onShow($scope) {
        console.log('Show');
    }

    /* Kendo event object*/
    onLogin() {

    }
}

LoginCtrl.$inject = ['$scope', '$injector', '$sanitize', 'provider', 'jsdoSessions', '$kinvey'];

export default LoginCtrl