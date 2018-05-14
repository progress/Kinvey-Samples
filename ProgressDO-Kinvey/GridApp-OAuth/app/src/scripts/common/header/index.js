'use strict';

import angular from 'angular';

const HeaderCtrl = function($rootScope, $scope, $state, $window, $document, providerService,$kinvey) {
    $scope.hasAuthProviders = false;
    $scope.showLogout = false;

    $scope.logout = function() {
        $kinvey.User.logout()
            .then(function() {
                activate();
                $rootScope.hasAuthProviders = false;
                $state.go('login');
            });
    };

    $scope.toggleLogout = function() {
        $scope.showLogout = !$scope.showLogout;
    };

    angular.element($window).resize(hideLogout);
    angular.element($document).click(hideLogout);

    function hideLogout(e) {
        if (angular.element(e.target).closest('.login').length > 0) {
            return;
        }
        $scope.showLogout = false;
        $scope.$apply();
    }

    function activate() {
        const watchHandler = $scope.$watch(() => {
            var registratedProviders = providerService.registeredProviders
                .map((providerName) => providerService.dataProviders[providerName]);
            return registratedProviders;
        }, (registeredProviders) => {
            const authProviders = registeredProviders.filter(provider => provider.authenticationModel !== 'Anonymous')
            if (authProviders.length > 0) {
                $scope.hasAuthProviders = true;
                watchHandler();
            }
        }, true);
    }

    activate();
};

HeaderCtrl.$inject = ['$rootScope', '$scope', '$state', '$window', '$document', 'providerService', '$kinvey'];

export default HeaderCtrl;