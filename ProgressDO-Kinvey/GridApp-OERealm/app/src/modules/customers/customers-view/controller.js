///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

class BaseController {
    constructor($scope, $injector) {
        this.$scope = $scope;
        this.$dataProviderService = $injector.get('providerService');
        this.$dsService = $injector.get('dsService');
        this.$translate = $injector.get('$translate');
        this.$compile = $injector.get('$compile');

        this.$dsOptions = {};
        this.$ds = {};

        this.$primeDSName = '$primeDS';
        this.$dsOptions[this.$primeDSName] = {
            transport: {
                jsdo: "Customer"
            },
            type: "jsdo",
            pageSize: 10,
        };
        this.$ds[this.$primeDSName] = new kendo.data.DataSource(this._$getDataSourceOptions(this.$primeDSName));
        this.$ds[this.$primeDSName].bind('error', this._$errorHandler.bind(this));

        this.$model = {
            title: 'Customers',
            options: {
                pageable: {
                    pageSize: 10,
                    refresh: true
                },
                toolbar: [{
                    "name": "create",
                    "iconClass": "k-icon k-i-track-changes"
                }],
                messages: {
                    commands: {}
                },
                editable: 'popup',
                selectable: true,
                filterable: true,
                groupable: true,
                resizable: true,
                reorderable: true,
                sortable: true,
                columns: [{
                        encoded: true,
                        field: "CustNum",
                        filterable: true,
                        format: "",
                        sortable: true,
                        title: "Cust Num"
                    },
                    {
                        encoded: true,
                        field: "Name",
                        filterable: true,
                        format: "",
                        sortable: true,
                        title: "Name"
                    },
                    {
                        encoded: true,
                        field: "Country",
                        filterable: true,
                        format: "",
                        sortable: true,
                        title: "Country"
                    },
                    {
                        encoded: true,
                        field: "Balance",
                        filterable: true,
                        format: "",
                        sortable: true,
                        title: "Balance"
                    },
                    {
                        encoded: true,
                        field: "CreditLimit",
                        filterable: true,
                        format: "",
                        sortable: true,
                        title: "Credit Limit"
                    },
                    {
                        command: [{
                                name: "edit",
                                iconClass: "fa fa-pencil"
                            },
                            {
                                name: "destroy",
                                iconClass: "k-icon k-i-delete"
                            }
                        ],
                        title: "&nbsp;",
                        width: 250
                    }
                ],
                dataSource: this.$ds[this.$primeDSName]
            },
            customSections: {
                top: 'views.customers.customers-view.topSection.html',
                middle: 'views.customers.customers-view.middleSection.html',
                bottom: 'views.customers.customers-view.bottomSection.html'
            },
            events: {
                onRowSelect: (e) => {
                    this['onRowSelect'](e);
                },
                onRowCreate: (e) => {},
                onRowUpdate: (e) => {},
                onRowDelete: (e) => {}
            }
        };
        this._$translate();
    }

    $onInit() {
        this.$scope.$on('$includeContentLoaded', () => {
            if (this.includeContentLoaded) {
                this.includeContentLoaded();
            }
        });

        this.$scope.$on('$viewContentLoaded', (e) => {
            if (this['onShow']) {
                this['onShow'](e.currentScope);
            }
        });

        this.$scope.$on('$includeContentError', (e) => {
            if (this.includeContentError) {
                this.includeContentError();
            }
        });

        this.$scope.$on('$destroy', this._$destroy.bind(this));
    }

    _$getDataSourceOptions(name) {
        return this.$dsOptions[name];
    }

    _$errorHandler(e) {
        const message = this.$dsService.extractErrorMessage(e);

        this.$scope.$emit('notification', {
            type: 'error',
            message: message
        });
    }

    _$requestStartHandler(e) {
        if (e.type !== 'update' &&
            e.type !== 'create' &&
            e.type !== 'submit' &&
            e.type !== 'destroy' &&
            e.sender.hasChanges() &&
            confirm(that.$pendingChangeMessage)) {
            e.preventDefault();
        }
    }

    _$translate() {
        var model = this.$model;
        this.$translate('modules.Customers.views.CustomersView.title')
            .then(function(title) {
                model.title = title;
            });

        this.$translate(["modules.Customers.views.CustomersView.columns.CustNum", "modules.Customers.views.CustomersView.columns.Name", "modules.Customers.views.CustomersView.columns.Country", "modules.Customers.views.CustomersView.columns.Balance", "modules.Customers.views.CustomersView.columns.CreditLimit", "modules.Customers.views.CustomersView.columns.undefined"])
            .then(function(translations) {
                Object.keys(translations).forEach(function(namespacedKey) {
                    var keyParts = namespacedKey.split('.');
                    var key = keyParts[keyParts.length - 1];
                    model.options.columns.forEach(function(column) {
                        if (key === column.field) {
                            column.title = translations[namespacedKey];
                        }
                    });
                });
            });

        if (model.options.messages) {
            this.$translate(["modules.Customers.views.CustomersView.editMessages.cancel", "modules.Customers.views.CustomersView.editMessages.create", "modules.Customers.views.CustomersView.editMessages.save", "modules.Customers.views.CustomersView.editMessages.canceledit", "modules.Customers.views.CustomersView.editMessages.destroy", "modules.Customers.views.CustomersView.editMessages.edit", "modules.Customers.views.CustomersView.editMessages.update"])
                .then(function(translations) {
                    var editMessages = {};
                    Object.keys(translations).forEach(function(namespacedKey) {
                        var keyParts = namespacedKey.split('.');
                        var key = keyParts[keyParts.length - 1];
                        editMessages[key] = translations[namespacedKey];
                    });
                    model.options.messages.commands = editMessages;
                });
        }
    }

    _$destroy() {

        this.$ds[this.$primeDSName].unbind('error', this._$errorHandler);
    }
}

export default BaseController