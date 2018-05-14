///////////////////
// Auto-generated
// Do not edit!!!
///////////////////

function routing($stateProvider) {
    $stateProvider
        .state('module.default.customers.customersView', {
            url: '/customers-view',
            templateProvider: [() => require.ensure([], (require) => require('./template.html'))],
            controller: 'CustomersCustomersViewCtrl',
            controllerAs: 'vm',
            authorization: {
                allowedRoles: []
            },
            data: {
                providers: ["CustomerProvider"]
            },
            resolve: {
                stateData: ['$ocLazyLoad', '$injector', '$stateParams', ($ocLazyLoad, $injector, $stateParams) => {
                    return require.ensure([], (require) => {
                            let module = require('./index.js');

                            return $ocLazyLoad.load({
                                name: 'views.customers.customers-view'
                            });
                        })
                        .then((module) => $injector.get('customersCustomersView')['onInit']($stateParams));
                }]
            },
            onExit: ['$injector', 'stateData', function($injector, stateData) {
                $injector.get('customersCustomersView')['onHide'](stateData);
            }]
        });
}

export default routing;