/////////////////////////////////////////////////////
// Add your custom code here.
// This file and any changes you make to it are preserved every time the app is generated.
/////////////////////////////////////////////////////
import BaseController from './controller.js'

class CustomersCustomersViewCtrl extends BaseController {
    constructor($scope, $injector, stateData) {
        super($scope, $injector);
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
    onRowSelect(e) {

    }

}

CustomersCustomersViewCtrl.$inject = ['$scope', '$injector', 'stateData'];

export default CustomersCustomersViewCtrl