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

        this.$ds = new kendo.data.DataSource({

            transport: this.$dataProviderService.getTransport('DataProvider2', {
                "jsdo": "Customer"
            }),

            type: "jsdo",

            pageSize: 20,

        });
        this.$ds.bind('error', this._$errorHandler.bind(this));

        this.$model = {
            title: '&lt;Title&gt;',
            options: {
                pageable: {
                    pageSize: 20,
                    refresh: true
                },

                editable: 'readonly',
                selectable: true,
                filterable: false,
                groupable: false,
                resizable: false,
                reorderable: false,
                sortable: false,
                columns: [{
                        "encoded": true,
                        "field": "CUSTOMER_ID",
                        "filterable": true,
                        "format": "",
                        "sortable": true,
                        "title": "CUSTOMER_ID"
                    },
                    {
                        "encoded": true,
                        "field": "COMPANY_NAME",
                        "filterable": true,
                        "format": "",
                        "sortable": true,
                        "title": "COMPANY_NAME"
                    },
                    {
                        "encoded": true,
                        "field": "PRIMARY_CONTACT",
                        "filterable": true,
                        "format": "",
                        "sortable": true,
                        "title": "PRIMARY_CONTACT"
                    },
                    {
                        "encoded": true,
                        "field": "ACCOUNT_MANAGER",
                        "filterable": true,
                        "format": "",
                        "sortable": true,
                        "title": "ACCOUNT_MANAGER"
                    }
                ],
                dataSource: this.$ds
            },
            customSections: {
                top: 'views.test.test.topSection.html',
                middle: 'views.test.test.middleSection.html',
                bottom: 'views.test.test.bottomSection.html'
            },
            events: {
                onRowSelect: (e) => {

                    this['onRowSelect'](e);

                },
                onRowCreate: (e) => {

                },
                onRowUpdate: (e) => {

                },
                onRowDelete: (e) => {

                }
            }
        };
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

    _$errorHandler(e) {
        const message = this.$dsService.extractErrorMessage(e);

        this.$scope.$emit('notification', {
            type: 'error',
            message: message
        });
    }

    _$destroy() {
        this.$ds.unbind('error', this._$errorHandler);

    }
}

export default BaseController