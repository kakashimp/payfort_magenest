package com.magenest.payfort.payfort_magenest;

import java.util.Map;

/**
 * Created by trang on 18/2/21.
 */

public interface IPaymentRequestCallBack {
    void onPaymentRequestResponse(int responseType, Map<String, Object> responseData);
}
