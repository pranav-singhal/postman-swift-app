//
//  MdViewer.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 10/05/23.
//

import SwiftUI
import Down

struct MdViewer: View {
    let mdString: String? ;

    @State var isExpanded: Bool = false;

    var body: some View {
        VStack(alignment: .leading) {
                MarkdownView(markdown: mdString ?? "")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: isExpanded ? .infinity: 300)
                    .border(Color.accentColor)
            HStack() {
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: isExpanded ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        Text(isExpanded ? "Read Less": "Read More")
                            .padding()
                    }
                }
            }
        }
        .padding()
    }
}

struct MdViewer_Previews: PreviewProvider {
    static var previews: some View {
        MdViewer(mdString: "Razorpay is an Indian payments solution provider that allows businesses to accept, process and disburse payments with its product suite. Razorpay APIs are completely RESTful and all our responses are returned in JSON.\n\n\n# API Authentication\n\nAll Razorpay APIs are authenticated using **Basic Auth**. Basic auth requires the following:\n\n- [YOUR_KEY_ID]\n- [YOUR_KEY_SECRET]\n\nBasic auth expects an Authorization header for each request in the Basic base64token format. Here, base64token is a base64 encoded string of YOUR_KEY_ID:YOUR_KEY_SECRET.\n\n<table>\n<b>Watch Out!</b> <br>\nThe Authorization header value should strictly adhere to the format mentioned above. Invalid formats will result in authentication failures. Few examples of invalid headers are:\n\n- BASIC base64token\n- basic base64token\n- Basic \"base64token\"\n- Basic $base64token\n</table>\n\n# Generate API Key\n\nYou can use Razorpay APIs in two modes, Test and Live. The API key is different for each mode.\n\nTo generate the API keys:\n1. Log into the <a href=\"https://dashboard.razorpay.com/app/dashboard\" target=\"_blank\">Razorpay Dashboard</a>.\n2. Select the mode (Test or Live) for which you want to generate the API key.\n<br>- Test Mode: The test mode is a simulation mode that you can use to test your integration flow. Your customers will not be able to make payments in this mode.\n<br>- Live Mode: When your integration is complete, in the Dashboard, switch to the live mode and generate live mode API keys. Replace test mode keys with live mode keys in the integration to accept payments from customers.\n3. Navigate to Settings → API Keys → Generate Key to generate key for the selected mode.\n\n# Errors\nAll successful responses are returned with HTTP Status code 204. In case of failure, API returns a JSON error response with the parameters that contain the failure reason.\n\n# Understanding Error Response\n\nThe error response contains `code`, `description`, `field`, `source`, `step`, and `reason` parameters to understand and troubleshoot the error.\n\nLet us take an example where a merchant tries to add new allowed payer accounts when the overall limit is exceeded.\n\n```json: \n{\n  \"error\": {\n    \"code\": \"BAD_REQUEST_ERROR\",\n    \"description\": \"Authentication failed due to incorrect otp\",\n    \"field\": null,\n    \"source\": \"customer\",\n    \"step\": \"payment_authentication\",\n    \"reason\": \"invalid_otp\",\n    \"metadata\": {\n      \"payment_id\": \"pay_EDNBKIP31Y4jl8\",\n      \"order_id\": \"order_DBJKIP31Y4jl8\"\n    }\n  }\n}\n```\n\n### Response Parameters\n\n`error`\n: `object` The error object.\n\n`code`\n: `string` Type of the error.\n\n`description`\n: `string` Description of the error.\n\n`field`\n: `string` Name of the parameter in the API request that caused the error.\n\n`source`\n: `string` The point of failure in the specific operation (payment in this case). For example, customer, business\n\n`step`\n: `string` The stage where the transaction failure occurred. The stages can vary depending on the payment method used to complete the transaction.\n\n`reason`\n: `string` The exact error reason. It can be handled programmatically.\n\n`metadata`\n: `object` Contains additional information about the request.\n\n    `payment_id`\n    : `string` Unique identifier of the payment.\n\n    `order_id`\n    : `string` Unique identifier of the order associated with the payment.\n\nKnow more about <a href=\"/docs/errors/error-codes\" target=\"_blank\">Error Codes</a>.")
    }
}


struct MarkdownView: UIViewRepresentable {
    let markdown: String

    func makeUIView(context: Context) -> UIView {
        let downView = try! DownView(frame: .zero, markdownString: markdown, openLinksInBrowser: true, options: .smartUnsafe)

        return downView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
