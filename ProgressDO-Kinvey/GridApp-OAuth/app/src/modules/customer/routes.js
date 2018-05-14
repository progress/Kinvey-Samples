///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
import customerRoute from './customer/route.js';

routing.$inject = ['$stateProvider'];

function routing($stateProvider) {
    $stateProvider
        .state('module.default.customer', {
            abstract: true,
            url: '/customer',
            views: {
                'content@module': {
                    template: '<div ui-view></div>',
                    controller: 'CustomerCtrl'
                }
            }
        });

    customerRoute($stateProvider);
}

export default routing;