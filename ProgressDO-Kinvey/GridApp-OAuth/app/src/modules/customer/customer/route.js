///////////////////
// Auto-generated
// Do not edit!!!
///////////////////

function routing($stateProvider) {
    $stateProvider
        .state('module.default.customer.customer', {
            url: '/customer',
            templateProvider: [() => require.ensure([], (require) => require('./template.html'))],
            controller: 'CustomerCustomerCtrl',
            controllerAs: 'vm',
            data: {
                providers: ["DataProvider1"]
            },
            resolve: {
                stateData: ['$ocLazyLoad', '$injector', '$stateParams', ($ocLazyLoad, $injector, $stateParams) => {
                    return require.ensure([], (require) => {
                            let module = require('./index.js');

                            return $ocLazyLoad.load({
                                name: 'views.customer.customer'
                            });
                        })
                        .then((module) => $injector.get('customerCustomer')['onInit']($stateParams));
                }]
            },
            onExit: ['$injector', 'stateData', function($injector, stateData) {
                $injector.get('customerCustomer')['onHide'](stateData);
            }]
        });
}

export default routing;