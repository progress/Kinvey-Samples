///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
import headerTemplate from './../../../scripts/common/header/index.html';

function routing($stateProvider) {
    $stateProvider
        .state('default.module.application.unauthorized', {
            url: '/unauthorized',
            views: {
                'header@default': {
                    templateUrl: headerTemplate,
                    controller: 'HeaderCtrl'
                },
                'content@default': {
                    templateProvider: [() => require.ensure([], (require) => require('./index.html'))],
                    controller: 'UnauthorizedPageCtrl',
                    controllerAs: 'vm'
                }
            },
            resolve: {
                stateData: ['$ocLazyLoad', '$injector', '$stateParams', ($ocLazyLoad, $injector, $stateParams) => {
                    return require.ensure([], (require) => {
                            let module = require('./index.js');

                            return $ocLazyLoad.load({
                                name: 'views.application.unauthorized-page'
                            });
                        })
                        .then((module) => $injector.get('applicationUnauthorized-page')['onInit']($stateParams));
                }]
            },
            onExit: ['$injector', 'stateData', function($injector, stateData) {
                $injector.get('applicationUnauthorized-page')['onHide'](stateData);
            }]
        });
}

export default routing;