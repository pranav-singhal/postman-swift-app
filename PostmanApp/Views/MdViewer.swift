//
//  MdViewer.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 10/05/23.
//

import SwiftUI
import Down

struct MdViewer: View {
    @Binding var mdString: String? ;

    @State var isExpanded: Bool = false;

    var body: some View {
        VStack(alignment: .leading) {
                MarkdownView(markdown: mdString ?? "")
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: isExpanded ? .infinity: 500)

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
        let jsonString: String =        """
```
{
    "collections":
[{"id":"e8ac9571-f71a-49b4-9be8-c87b5414c703","name":"Postman API","owner":"27522068","createdAt":"2023-05-19T18:21:30.000Z","updatedAt":"2023-05-20T04:13:20.000Z","uid":"27522068-e8ac9571-f71a-49b4-9be8-c87b5414c703","fork":{"label":"pranmav-singhal123's fork","createdAt":"2020-10-21T00:20:52.000Z","from":"12959542-c8142d51-e97c-46b6-bd77-52bb66712c9a"},"isPublic":false},{"id":"96365c02-dbcf-48b6-90d9-edd83d29cb44","name":"Razorpay APIs","owner":"27522068","createdAt":"2023-05-20T04:34:52.000Z","updatedAt":"2023-05-20T04:34:52.000Z","uid":"27522068-96365c02-dbcf-48b6-90d9-edd83d29cb44","fork":{"label":"pranmav-singhal123's fork","createdAt":"2022-02-08T06:53:52.000Z","from":"12492020-952c7295-118c-400f-8f2c-5266ef6f689a"},"isPublic":false},{"id":"68df7afd-33e7-47ec-b47f-6092edb1db45","name":"testing-headers","owner":"27522068","createdAt":"2023-05-25T17:33:33.000Z","updatedAt":"2023-05-25T17:33:35.000Z","uid":"27522068-68df7afd-33e7-47ec-b47f-6092edb1db45","isPublic":false}]}
```
"""
        MdViewer(mdString: .constant(jsonString))
    }
}


struct MarkdownView: UIViewRepresentable {
    let markdown: String

    func makeUIView(context: Context) -> UIView {
        let downView = try! DownView(frame: .zero, markdownString: markdown, openLinksInBrowser: true, options: .smartUnsafe);

        return downView;
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
