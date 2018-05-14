///////////////////
// Auto-generated
// Do not edit!!!
///////////////////
'use strict';

class BaseController {
    constructor($scope, $injector, $sanitize, provider, jsdoSessions, $kinvey) {
        this.$scope = $scope;
        this.$kinvey = $kinvey;
        this.$injector = $injector;
        this.$sanitize = $sanitize;
        this.$jsdoSessions = jsdoSessions;
        this.$provider = provider;
        this.$message = '';
        this.$errored = false;
        this.$loading = false;
        this.$title = $sanitize('<Title>');
        this.$customSections = {
            top: 'views.application.login.topSection.html',
            middle: 'views.application.login.middleSection.html',
            bottom: 'views.application.login.bottomSection.html'
        };
    }

    $onInit() {
        this.$scope.$on('$viewContentLoaded', (e) => {
            if (this['onShow']) {
                this['onShow'](e.currentScope);
            }
        });
    }

    _$onError(err) {
        this.$form.$setPristine();
        this.$form.$setUntouched();
        this.$password = '';
        this.$errored = true;
        this.$message = err.message;
    }

    _$onSuccess() {
        this['onLogin'](this.$scope);
        this.$scope.$close();
    }

    _$onRequestEnd() {
        this.$loading = false;
    }

    _$shouldDisable() {
        return this.$form.$invalid || this.$loading;
    };

    _loginWithMIC() {
        this.$scope.showError = false;
        this.$kinvey.User.loginWithMIC('http://localhost:5200')
          .then(() => this._$onSuccess())
          .catch((err) => this._$onError(err));
      };

    _$onSubmit() {
        this.$loading = true;

        this.$kinvey.User.login(this.$username, this.$password)
            .then(() => this._$onSuccess())
            .catch((err) => this._$onError(err));

        // this.$jsdoSessions.login(this.$provider, {
        //         username: this.$username,
        //         password: this.$password
        //     })
        //     .then(() => this._$onSuccess())
        //     .catch((err) => this._$onError(err))
        //     .finally(() => this._$onRequestEnd());
    };

    _$onClose() {
        this.$scope.$dismiss({
            message: 'Authentication Canceled'
        });
    };
}

BaseController.$inject = ['$scope', '$injector','$kinvey'];

export default BaseController;