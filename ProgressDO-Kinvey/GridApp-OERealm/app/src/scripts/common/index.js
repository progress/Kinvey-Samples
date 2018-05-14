///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
import angular from 'angular';

import translation from './translation';

import HeaderCtrl from './header';
import SideNavigationCtrl from './side-navigation';

import authorizationDirective from './authorization';

/* Partial Views */
import headerTemplate from './header/index.html';
import sideNavigationTemplate from './side-navigation/index.html';

routing.$inject = ['$stateProvider'];

function routing($stateProvider) {
    $stateProvider
        .state('default.module', {
            url: '',
            abstract: true
        })
        .state('module', {
            url: '',
            abstract: true,
            templateUrl: 'module-template'
        })
        .state('module.default', {
            url: '/module',
            abstract: true,
            views: {
                'header': {
                    templateUrl: headerTemplate,
                    controller: 'HeaderCtrl'
                },
                'side-navigation': {
                    templateUrl: sideNavigationTemplate,
                    controller: 'SideNavigationCtrl'
                }
            }
        })
}

export default angular.module('app.common', [translation])
    .controller('SideNavigationCtrl', SideNavigationCtrl)
    .controller('HeaderCtrl', HeaderCtrl)
    .config(routing)
    .directive('showForRoles', authorizationDirective)
    .name;