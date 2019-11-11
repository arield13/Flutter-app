/*
 * FILE CONSTANTS PROJECT
 */

//BASE URL
/*const String BASE_URL =
    "https://monitor30-dot-stunning-base-164402.appspot.com"; //PROD*/
import 'dart:ui';

const String BASE_URL =
    "http://nosiclean.ca:8080/spring-turnet-1.0-SNAPSHOT"; //DEV
/*const String BASE_URL =
    "https://monitor30-dot-stunning-base-164402.appspot.com"; //PROD*/

const String BASE_PAYMENTS_URL =
    "https://dev-dot-payments-dot-stunning-base-164402.appspot.com/_ah/api"; //DEV
/*const String BASE_PAYMENTS_URL =
    "https://payments-dot-stunning-base-164402.appspot.com/_ah/api"; //PROD*/

const String BASE_BACKEND_2_0_URL =
    "https://dev-dot-monitor-dot-stunning-base-164402.appspot.com/_ah/api"; //DEV
/*const String BASE_PAYMENTS_URL =
    "https://monitor-dot-stunning-base-164402.appspot.com/_ah/api"; //PROD*/

//ENPOINTS SERVICES
const String USER_CREATE =
    BASE_URL + "/clients/client";

const String CLIENTS =
    BASE_URL + "/clients/suppliers";

const String APPOINMENT =
    BASE_URL + "/appoinment/appoinmentsclient";

const String APPOINMENT_COMMERCE =
    BASE_URL + "/appoinment/appoinmentscomerce";

const String NOTIFICATION =
    BASE_URL + "/clients/notification/token";

const String USER_LOGIN =
    BASE_URL + "/oauth/token";

const String USER_DETAIL =
    BASE_URL + "/clients/userdetail";
const String RECOVERY_PASSWORD =
    BASE_URL + "/backend/flexible/v2/monitor/recoveryPassword";
const String CHANGE_PASSWORD =
    BASE_URL + "/backend/flexible/v2/monitor/changePassword";
const String GET_ORDER =
    BASE_URL + "/backend/flexible/v2/monitor/getOrderHeadCourier";
const String UPDATE_ORDER_COURIER_STATUS =
    BASE_URL + "/backend/flexible/v2/monitor/addOrderCourierStatus";
const String VALIDATE_ORDER_ASSIGNED =
    BASE_URL + "/backend/flexible/v2/monitor/isOrderAssigned";
const String DETAIL_ORDER =
    BASE_URL + "/backend/flexible/v2/monitor/getOrderDetail20";
const String ORDER_STORES =
    BASE_URL + "/backend/flexible/v2/monitor/getOrderStores";
const String ADD_ORDER_MESSENGER_TRACING =
    BASE_URL + "/backend/flexible/v2/monitor/addOrderMessengerTracing";
const String ORDER_STATUS =
    BASE_URL + "/backend/flexible/v2/monitor/getOrderStatus";
const String GET_ORDER_MESSENGER_TRACING =
    BASE_URL + "/backend/flexible/v2/monitor/getOrderMessengerTracing";
const String GET_HISTORY_ORDERS_MESSENGER_BY_YEAR =
    BASE_URL + "/backend/flexible/v2/monitor/getHistoryOrdersMessengerByYear";
const String GET_HISTORY_ORDERS_MESSENGER =
    BASE_URL + "/backend/flexible/v2/monitor/getHistoryOrdersMessenger";
const String GET_ORDERS_MESSENGER_TODAY_EARNINGS =
    BASE_URL + "/backend/flexible/v2/monitor/getOrdersMessengerTodayEarnings";
const String GET_ORDERS_MESSENGER_EARNINGS_BY_WEEK =
    BASE_URL + "/backend/flexible/v2/monitor/getOrdersMessengerEarningsByWeek";
const String ADD_ORDER_EVIDENCE =
    BASE_URL + "/backend/flexible/v2/monitor/addOrderEvidence";
const String ADD_ORDER_POS_NUMBER =
    BASE_URL + "/backend/flexible/v2/monitor/addOrderPosNumber";
const String ADD_ORDER_MESSENGER_EARNING =
    BASE_URL + "/backend/flexible/v2/monitor/addOrderMessengerEarning";
const String GET_TOKEN_2 = BASE_URL + "/backend/flexible/v2/monitor/getToken2";
const String GET_TOKEN_3 = BASE_URL + "/backend/flexible/v2/monitor/getToken3";
const String GET_STATUS_CHANGE_PAYMENT_METHOD =
    BASE_URL + "/backend/flexible/v2/monitor/getStatusChangePaymentMethod";

//ENPOINTS SERVICES PAYMENTS
const String CHANGE_ORDER = BASE_PAYMENTS_URL + "/chargeEndpoint/chargeOrder";

//ENPOINTS SERVICES BACKEND
const String CHANGE_PAYMENT_METHOD =
    BASE_BACKEND_2_0_URL + "/orderMonitorEndpoint/updateOrderPaymentMethod";

//SOCKET
/*const String URL_SOCKET =
    "https://monitor-server-dot-web-farmatodo.appspot.com"; //PROD*/
const String URL_SOCKET =
    "https://dev2-dot-monitor-server-dot-web-farmatodo.appspot.com"; //DEV
const String PUSH_ORDER_CHANNEL = "push-order";

//ORDER STATUS
const String ASSIGNED = "3";
const String PICKING = "4";
const String BILLED = "5";
const String DELIVERY = "6";
const String FINISH = "7";
const String SEND = "32";
const String DELIVERY_POINT = "33";
const String PICKING_POINT_TRANSFER = "34";
const String PICKING_TRANSFER = "35";
const String PICKING_FINISH_TRANSFER = "36";
const String PICKING_FINISH = "37";
const String SCANNING_DATAPHONE = "38";
const String CAPTURING_VOUCHER = "39";
const String COLLECTING_ONLINE = "40";
const String CHANGE_PAYMENT_METHOD_DATAPHONE_TO_EFECTY = "41";
const String CHANGE_PAYMENT_METHOD_ONLINE_TO_EFECTY = "42";
const String CHANGE_PAYMENT_METHOD_ONLINE_TO_DATAPHONE = "43";
const String ONLINE_PAYMENT = "44";
const String EFECTY_PAYMENT = "45";
const String DATAPHONE_PAYMENT = "46";
const String PENDING_RETURN_IN_STORE = "26";

//CONFIG
const double RADIO_ARRRIVED_STORE = 0.05;

//COLORS
const Color COLOR_NO_ACTION = Color.fromARGB(105, 105, 105, 105);
const Color COLOR_PICKING = Color.fromARGB(255, 80, 227, 194);

//DEPARTAMENTS COLORS
const Color COLOR_BABY_CARE = Color.fromARGB(255, 20, 197, 199);
const Color COLOR_HEALTH_AND_MEDICINES = Color.fromARGB(255, 132, 210, 76);
const Color COLOR_FOOD_AND_DRINKS = Color.fromARGB(255, 65, 143, 222);
const Color COLOR_BEAUTY = Color.fromARGB(255, 177, 68, 151);
const Color COLOR_HOME_PETS_AND_OTHERS = Color.fromARGB(255, 65, 143, 222);
const Color COLOR_PERSONAL_CARE = Color.fromARGB(255, 99, 66, 143);

//DEPARTAMENTS ID
const int BABY_CARE = 154;
const int HEALTH_AND_MEDICINES = 1;
const int FOOD_AND_DRINKS = 71;
const int BEAUTY = 72;
const int HOME_PETS_AND_OTHERS = 73;
const int PERSONAL_CARE = 178;

//PAYMENTS METHODS ID
const int EFECTY_ID = 1;
const int DATAPHONE_ID = 2;
const int PAY_ONLINE_ID = 3;
