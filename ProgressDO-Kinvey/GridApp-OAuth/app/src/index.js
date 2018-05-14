///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
//Vendors
import angular from 'angular';

//App
import services from './scripts/services';
import common from './scripts/common';
import filters from './scripts/filters';
import components from './scripts/components';
import extensions from './scripts/extensions';
import modules from './modules';

//Styles

import './styles/app/app.css';
import './styles/app/kendo.overrides.css';
import './styles/app/app.custom.css';

var kinveyInitialized = false;

export default angular
    .module('app.kinvey-o-auth', [
        'ui.router',
        'kinvey',
        'oc.lazyLoad',
        'ngAnimate',
        'ngSanitize',
        'kendo.directives',
        services,
        common,
        filters,
        components,
        extensions,
        modules
    ])
    .run(['$rootScope', '$kinvey', '$state', '$window', 'providerService', 'authService', ($rootScope, $kinvey, $state, $window, providerService, authService) => {
        if (kinveyInitialized === false) {
            event.preventDefault();
            $kinvey.initialize({
            appKey: 'kid_B1KcUrM5G',
            appSecret: '0b789165a4324a2b8a2f18ef7699c218',
            apiHostName: 'http://localhost:7007',
            micHostname: 'http://localhost:8081',
            clientAppVersion: 3
            })
            .then(function(activeUser) {
            kinveyInitialized = true;
            $state.go('login');
            })
            .catch(function(error) {
            console.log(error.message, error.name);
            });
            } else if (toState.requiresActiveUser === true && !$kinvey.User.getActiveUser()) {
            event.preventDefault();
            $state.go('login');
            }
            
        
        $rootScope.hasAuthProviders = false;
        $rootScope.$on('$stateChangeStart', (event, toState, toParams) => {
            const allStates = $state.get();
            let hasModuleWithProvider = false;
            for (let state of allStates) {
                if (state.data && state.data.providers && state.data.providers.length) {
                    hasModuleWithProvider = true;
                    break;
                }
            }

            if (!hasModuleWithProvider) {
                $rootScope.hasAuthProviders = true;
            }

            if (!$rootScope.hasAuthProviders && toState.name === 'default.module.application.home') {
                event.preventDefault();
                $state.go('login', {
                    returnState: toState.name
                });
            }

            let providerNames = toState.data ? toState.data.providers : [];
            let unregisteredProviders = providerNames.filter((providerName, index, array) => {
                return providerService.registeredProviders.indexOf(providerName) === -1 && array.indexOf(providerName) === index;
            });

            if (unregisteredProviders.length) {
                event.preventDefault();
                authService.authenticate(unregisteredProviders)
                    .then(() => {
                        $rootScope.hasAuthProviders = true;
                        $state.go(toState.name, toParams);
                    })
                    .catch((err) => {
                        $rootScope.$emit('notification', {
                            type: 'error',
                            message: err.message || err
                        });
                    });
            }
        });

        angular.element($window).on('resize', function() {
            $rootScope.$broadcast('windowResize', $window);
        });
    }])
    .config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) => {
        $stateProvider
            .state('default', {
                url: '',
                abstract: true,
                templateUrl: 'home-template'
            });

        $urlRouterProvider.otherwise(($injector) => {
            const $state = $injector.get("$state");

            $state.go('default.module.application.home');
        });
    }]).name;