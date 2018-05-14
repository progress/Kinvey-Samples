///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

class BaseController {
    constructor($scope, $injector) {
        this.$scope = $scope;
        this.$injector = $injector;
        this.$authService = this.$injector.get('authService');
        this.$translate = $injector.get('$translate');
        this.$TOLERANCE = 151; // needed for very edge cases when someone clicks with the speed of light
        this.$customSections = {
            top: 'views.application.landing-page.topSection.html',
            bottom: 'views.application.landing-page.bottomSection.html'
        };
        this.allowedModules = [];

        this.$tooltip = angular.element(".modules-list-wrapper").kendoTooltip({
            filter: "a[title]",
            content: (e) => {
                const model = e.target.scope().module;
                return model.description.length > 0 ? model.description : undefined
            },
            position: "bottom",
            width: 180,
        }).data("kendoTooltip");

        this.modules = [{
            description: '',
            thumbnail: {
                background: '#00a2e8',
                color: '#ffffff',
                icon: 'fa-area-chart',
            },
            label: '',
            name: 'Customers',
            state: 'module.default.customers.customersView'
        }];

        this._$translate();
    }

    $onInit() {
        this.$scope.$on('$viewContentLoaded', (e) => {
            if (this['onShow']) {
                this['onShow'](e.currentScope);
            }
        });

        this.$scope._$onHideTooltip = () => {
            setTimeout(() => {
                this.$tooltip.hide();
            }, this.$TOLERANCE);
        };

        this.addAllowedModules();
    }

    _$translate() {
        this.modules.forEach((module) => {
            this.$translate('modules.' + module.name + '.label')
                .then(function(label) {
                    module.label = label;
                });

            this.$translate('modules.' + module.name + '.description')
                .then(function(description) {
                    module.description = description;
                });
        });
    }

    addAllowedModules() {
        // When show landing-page we need to redirect to the first allowed view when clicking on module name
        this.modules.forEach((module, index) => {
            const stateService = this.$injector.get('$state');
            const state = stateService.get(module.state);
            if (state) {
                const parentStateName = state.name.substring(0, state.name.lastIndexOf("."));
                const parentState = stateService.get(parentStateName);

                if (parentState) {
                    // if parent (module) is allowed for the current user, find first authorized view and set it as link of module thimbnail
                    if (this.$authService.isAuthorized(parentState.authorization)) {
                        module.state = this.getFirstAllowedChildState(state, module.state, stateService, parentStateName);
                    } else {
                        module.state = '';
                    }
                }

                if (module.state) {
                    this.allowedModules.push(module);
                }
            }
        });
    }

    getFirstAllowedChildState(state, stateName, stateService, parentStateName) {
        // If the user lacks sufficient roles, do not include state as allowed.
        if (!this.$authService.isAuthorized(state.authorization)) {
            const childStates = stateService.get().filter(function(cState) {
                return cState.name.indexOf(parentStateName) === 0
            });

            let firstAuthorizedState = null;

            for (var index = 0; index < childStates.length; index++) {
                const st = childStates[index];
                if (!st.abstract) {
                    if (this.$authService.isAuthorized(st.authorization)) {
                        firstAuthorizedState = st;
                        break;
                    }
                }
            }

            if (firstAuthorizedState !== null) {
                stateName = firstAuthorizedState.name;
            } else {
                stateName = '';
            }
        }

        return stateName;
    }
}

BaseController.$inject = ['$scope', '$injector'];

export default BaseController