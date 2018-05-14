import BaseController from './controller.js'

class CustomerCustomerCtrl extends BaseController {
    constructor($scope, $injector, stateData, $kinvey) {
        super($scope, $injector);
       var that = this; 
       var store = $kinvey.DataStore.collection('Customer');
       store.find()
            .subscribe(function(customer) {
                that.$ds.data(customer);
            }, function(error) {
                console.log(error);
      });            
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

CustomerCustomerCtrl.$inject = ['$scope', '$injector', 'stateData', '$kinvey'];

export default CustomerCustomerCtrl