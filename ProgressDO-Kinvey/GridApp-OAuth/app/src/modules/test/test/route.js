///////////////////
// Auto-generated
// Do not edit!!!
///////////////////

function routing($stateProvider) {
    $stateProvider
        .state('module.default.test.test', {
            url: '/test',
            templateProvider: [() => require.ensure([], (require) => require('./template.html'))],
            controller: 'TestTestCtrl',
            controllerAs: 'vm',
            data: {
                providers: ["DataProvider2"]
            },
            resolve: {
                stateData: ['$ocLazyLoad', '$injector', '$stateParams', ($ocLazyLoad, $injector, $stateParams) => {
                    return require.ensure([], (require) => {
                            let module = require('./index.js');

                            return $ocLazyLoad.load({
                                name: 'views.test.test'
                            });
                        })
                        .then((module) => $injector.get('testTest')['onInit']($stateParams));
                }]
            },
            onExit: ['$injector', 'stateData', function($injector, stateData) {
                $injector.get('testTest')['onHide'](stateData);
            }]
        });
}

export default routing;