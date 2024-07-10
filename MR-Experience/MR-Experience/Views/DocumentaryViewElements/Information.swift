//
//  Information.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI
import UIKit

struct Information: View {
    let informationText: String
    var body: some View {
        VStack(alignment: .leading) {
                AttributedTextView(attributedString: MarkdownUI(inputString: informationText))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
    }
}

struct AttributedTextView: UIViewRepresentable {
    var attributedString: NSAttributedString
    func makeUIView(context: Context) -> UITextView {
        let text = UITextView()
        text.isEditable = false
        text.isScrollEnabled = true
        text.textContainerInset = .zero
        text.textContainer.lineFragmentPadding = 0
        return text
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }
}






func MarkdownUI(inputString: String) -> NSAttributedString {
    
    let boldRegexPattern = "\\*{2}(.*?)\\*{2}"
    let italicRegexPattern = "(?<!\\*)\\*(?!\\*)([^\\*\\*]+)\\*(?!\\*)"
    let titleRegexPattern = "# ([\\s\\S]*?)\\n"
    let listRegexPattern = "- ([\\s\\S]*?)\\n"
    let underlineRegexPattern = "<u>(.*?)</u>"
    let highlightRegexPattern = "==(.*?)=="
    let dividinglineRegexPattern = "---"
    let urlRegexPattern = "\\[(.*?)\\]\\((.*?)\\)"
    
    do {
        let boldRegex = try NSRegularExpression(pattern: boldRegexPattern, options: [])
        let italicRegex = try NSRegularExpression(pattern: italicRegexPattern, options: [])
        let titleRegex = try NSRegularExpression(pattern: titleRegexPattern, options: [])
        let listRegex = try NSRegularExpression(pattern: listRegexPattern, options: [])
        let underlineRegex = try NSRegularExpression(pattern: underlineRegexPattern, options: [])
        let highlightRegex = try NSRegularExpression(pattern: highlightRegexPattern, options: [])
        let dividinglineRegex = try NSRegularExpression(pattern: dividinglineRegexPattern, options: [])
        let urlRegex = try NSRegularExpression(pattern: urlRegexPattern, options: [])
        
        let nsString = inputString as NSString
        
        
        
        
        
        let boldResults = boldRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length))
        let italicResults = italicRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length))
        let titleResults = titleRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length))
        let listResults = listRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length))
        let underlineResults = underlineRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length))
        let highlightResults = highlightRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length))
        let dividinglineResults = dividinglineRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length))
        let urlResults = urlRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: nsString.length))
        let attributedString = NSMutableAttributedString(string: inputString)
        // Set default text color to white
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))
        
        
        // bold
        for result in boldResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 12/*UIFont.systemFontSize*/), range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        }
        // italic
        for result in italicResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 12), range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        }
        // title
        for result in titleResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        }
        // underline
        for result in underlineResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
        }
        // highlight
        for result in highlightResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
            attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
        }
        // list
        for result in listResults.reversed() {
            let range = result.range(at: 0)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
            // Add a line break before each list itemh
            if range.location > 0 {
                attributedString.replaceCharacters(in: NSRange(location: range.location - 1, length: 1), with: "\n")
            }
        }
        // url
        for result in urlResults.reversed() {
            let textRange = result.range(at: 1)
            let urlRange = result.range(at: 2)
                    
            let linkText = nsString.substring(with: textRange)
            let url = nsString.substring(with: urlRange)
            
            let linkAttributedString = NSMutableAttributedString(string: linkText)
            linkAttributedString.addAttribute(.link, value: url, range: NSRange(location: 0, length: linkAttributedString.length))
                    
            attributedString.replaceCharacters(in: result.range(at: 0), with: linkAttributedString)
        }
        // dividing line
        for result in dividinglineResults.reversed() {
            let range = result.range(at: 0)
            // Add a horizontal line as a separator
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 1))
                        lineView.backgroundColor = UIColor.white
            let image = lineView.asImage()
            let attachment = NSTextAttachment()
            attachment.image = image
            let imageString = NSAttributedString(attachment: attachment)
            attributedString.replaceCharacters(in: range, with: imageString)
        }
        
                
        // remove：'*', '# ', '<u>', '</u>', '=='
        let removePatterns = [
            "\\*",
            "# ",
            "<u>",
            "</u>",
            "=="]

        for pattern in removePatterns {
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                let results = regex.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length))
                
                for result in results.reversed() {
                    attributedString.replaceCharacters(in: result.range, with: "")
                }
            } catch {
                print("Error removing pattern: \(error)")
            }
        }

        
        return attributedString
    } catch {
        return NSAttributedString(string: inputString)
    }
}


extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}



// #Preview {
//     Information()
// }
