///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
import testRoute from './test/route.js';

routing.$inject = ['$stateProvider'];

function routing($stateProvider) {
    $stateProvider
        .state('module.default.test', {
            abstract: true,
            url: '/test',
            views: {
                'content@module': {
                    template: '<div ui-view></div>',
                    controller: 'TestCtrl'
                }
            }
        });

    testRoute($stateProvider);
}

export default routing;