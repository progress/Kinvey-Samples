///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

import angular from 'angular';

const HeaderCtrl = function($rootScope, $scope, $state, $window, $document, $timeout, providerService, translationsService, rolesService, emitService) {
    $scope.hasAuthProviders = false;
    $scope.showLogout = false;

    $scope.logoutAction = function() {
        providerService.unRegisterProviders()
            .then(function() {
                activate();
                rolesService.clearRoles();
                $rootScope.hasAuthProviders = false;
                $state.go('login');
            })
            .catch(function() {
                //Error handling
                $state.go('default.module.application.home');
            });
    };

    $scope.logout = function() {
        var triggerLogout = emitService.emit('logout');

        if (!triggerLogout.defaultPrevented) {
            $scope.logoutAction();
        }
    };

    $scope.toggleLogout = function() {
        $scope.showLogout = !$scope.showLogout;
    };

    $scope.languages = [{
        "label": "English",
        "culture": "en-US",
        "order": 0,
        "key": "translations.default"
    }];
    $scope.languageOptions = {
        animation: false,
        change: changeLanguage,
        dataTextField: "label",
        dataValueField: "key",
        dataSource: $scope.languages,
        value: translationsService.getLanguage(),
        dataBound: function() {
            this.list.width("auto");
            var listContainer = this.list.closest(".k-list-container");
            listContainer.width(listContainer.width() + kendo.support.scrollbar() + 30);
            this.list.css('right', '25px');
            this.wrapper.css('width', 'auto');
        }
    };

    function changeLanguage() {
        const selectedKey = this.value();
        const selectedLanguage = $scope.languages.find(x => x.key === selectedKey);

        translationsService.setLanguage(selectedKey);
        translationsService.setCulture(selectedLanguage.culture);

        $timeout(function() {
            $window.location.reload();
        });
    }

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

HeaderCtrl.$inject = ['$rootScope', '$scope', '$state', '$window', '$document', '$timeout', 'providerService', 'translationsService', 'rolesService', 'emitService'];

export default HeaderCtrl;