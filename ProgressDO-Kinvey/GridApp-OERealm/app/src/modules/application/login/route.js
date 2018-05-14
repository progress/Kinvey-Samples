///////////////////
// Auto-generated
// Do not edit!!!
///////////////////

function routing($stateProvider) {
    $stateProvider
        .state('login', {
            url: '/login/:returnState',
            controller: LoginStateCtrl,
            controllerAs: 'vm',
            resolve: {
                stateData: ['$ocLazyLoad', '$injector', '$stateParams', ($ocLazyLoad, $injector, $stateParams) => {
                    return require.ensure([], (require) => {
                            let module = require('./index.js');

                            return $ocLazyLoad.load({
                                name: 'views.application.login'
                            });
                        })
                        .then((module) => $injector.get('applicationLogin')['onInit']($stateParams));
                }]
            },
            onExit: ['$injector', 'stateData', function($injector, stateData) {
                $injector.get('applicationLogin')['onHide'](stateData);
            }]
        });
}

class LoginStateCtrl {
    constructor($state, $rootScope, $stateParams, providerService, authService, loginModal, stateData) {
        this.$rootScope = $rootScope;
        let unregisteredProviders = [];
        const allStates = $state.get();
        for (let state of allStates) {
            if (state.data && state.data.providers && state.data.providers.length) {
                let uniqueProviders = state.data.providers.filter((providerName, index, array) => {
                    return unregisteredProviders.indexOf(providerName) === -1 && array.indexOf(providerName) === index;
                });
                unregisteredProviders = unregisteredProviders.concat(uniqueProviders);
            }
        }

        if (!unregisteredProviders.length) {
            $state.go('default.module.application.home');
        }

        // Cache the stateData in order to pass it to the LoginCtrl on the lated state.
        loginModal.setStateData(stateData);

        authService.authenticate(unregisteredProviders, (err) => this._$errorHandler(err))
            .then(() => {
                providerService.providers().then((providers) => {
                    let hasProviderWithAuthModel = Object.values(providers)
                        .some(p => p.authenticationModel !== 'Anonymous');

                    if (providerService.registeredProviders.length) {
                        $rootScope.hasAuthProviders = true;
                        $state.go($stateParams.returnState || 'default.module.application.home');
                    } else if (!$rootScope.hasAuthProviders && hasProviderWithAuthModel) {
                        $state.reload();
                    }
                });
            })
            .catch((err) => this._$errorHandler(err));
    }

    _$errorHandler(err) {
        this.$rootScope.$emit('notification', {
            type: 'error',
            message: err.message || err
        });
    }
}

LoginStateCtrl.$inject = ['$state', '$rootScope', '$stateParams', 'providerService', 'authService', 'loginModal', 'stateData'];

export default routing;