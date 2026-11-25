Feature: Orders api tests

  Background:
    Given http baseUri is /api/
    And I set http headers to:
    | Accept        | application/json  |
    | Content-Type  | application/json  |

  Scenario: Create an order
    And I set http body to {"id":"1","product":"Arc Reactor","quantity":2,"price":99.99,"status":"PENDING"}
    When I POST /orders
    Then http response code should be 201
    And http response header Content-Type should be application/json
    And http response body path $.id should be 1
    And http response body path $.product should be Arc Reactor
    And http response body path $.quantity should be 2
    And http response body path $.price should be 99.99
    And http response body path $.status should be PENDING

  Scenario: Create a duplicate order
    And I set http body to {"id":"1","product":"Arc Reactor","quantity":2,"price":99.99,"status":"PENDING"}
    When I POST /orders
    Then http response code should be 400

  Scenario: Create a second order
    And I set http body to {"id":"2","product":"Vibranium Shield","quantity":1,"price":499.5,"status":"CONFIRMED"}
    When I POST /orders
    Then http response code should be 201
    And http response body path $.id should be 2
    And http response body path $.product should be Vibranium Shield
    And http response body path $.status should be CONFIRMED

  Scenario: List orders
    When I GET /orders
    Then http response code should be 200
    And http response body should be valid json
    And http response body is typed as array for path $
    And http response body is typed as array using path $ with length 2
    And http response body path $.[0].id should be 1
    And http response body path $.[1].id should be 2

  Scenario: Get order by ID
    When I GET /orders/1
    Then http response code should be 200
    And http response body path $.id should be 1
    And http response body path $.product should be Arc Reactor
    And http response body path $.quantity should be 2
    And http response body path $.price should be 99.99
    And http response body path $.status should be PENDING

  Scenario: Get missing order
    When I GET /orders/999
    Then http response code should be 404
    And http response body path $ should not have content

  Scenario: Update order status
    And I set http body to {"status":"SHIPPED"}
    When I PUT /orders/1/status
    Then http response code should be 200
    And http response body path $.id should be 1
    And http response body path $.status should be SHIPPED
    When I GET /orders/1
    Then http response code should be 200
    And http response body path $.status should be SHIPPED

  Scenario: Update status of missing order
    And I set http body to {"status":"SHIPPED"}
    When I PUT /orders/999/status
    Then http response code should be 404

  Scenario: Delete order
    When I DELETE /orders/2
    Then http response code should be 200
    When I GET /orders
    Then http response code should be 200
    And http response body is typed as array using path $ with length 1
    And http response body path $.[0].id should be 1
    When I DELETE /orders/999
    Then http response code should be 404
