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
// Define a struct that conforms to UIViewRepresentable to represent a UITextView
struct AttributedTextView: UIViewRepresentable {
    // Property to hold the attributed string to be displayed
    var attributedString: NSAttributedString
    func makeUIView(context: Context) -> UITextView {
        let text = UITextView()
        text.isEditable = false
        text.isScrollEnabled = true
        text.textContainerInset = .zero
        text.textContainer.lineFragmentPadding = 0
        return text
    }

    // Method to update the view with new data
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Set the attributed text for the text view
        uiView.attributedText = attributedString
    }
}





// Function to create an attributed string from a markdown-like input string
func MarkdownUI(inputString: String) -> NSAttributedString {
    // Define regex patterns for various markdown elements
    let boldRegexPattern = "\\*{2}(.*?)\\*{2}"
    let italicRegexPattern = "(?<!\\*)\\*(?!\\*)([^\\*\\*]+)\\*(?!\\*)"
    let titleRegexPattern = "# ([\\s\\S]*?)\\n"
    let listRegexPattern = "- ([\\s\\S]*?)\\n"
    let underlineRegexPattern = "<u>(.*?)</u>"
    let highlightRegexPattern = "==(.*?)=="
    let dividinglineRegexPattern = "---"
    let urlRegexPattern = "\\[(.*?)\\]\\((.*?)\\)"
    
    do {
        // Compile the regex patterns
        let boldRegex = try NSRegularExpression(pattern: boldRegexPattern, options: [])
        let italicRegex = try NSRegularExpression(pattern: italicRegexPattern, options: [])
        let titleRegex = try NSRegularExpression(pattern: titleRegexPattern, options: [])
        let listRegex = try NSRegularExpression(pattern: listRegexPattern, options: [])
        let underlineRegex = try NSRegularExpression(pattern: underlineRegexPattern, options: [])
        let highlightRegex = try NSRegularExpression(pattern: highlightRegexPattern, options: [])
        let dividinglineRegex = try NSRegularExpression(pattern: dividinglineRegexPattern, options: [])
        let urlRegex = try NSRegularExpression(pattern: urlRegexPattern, options: [])
        // Convert the input string to NSString for easier range handling
        let nsString = inputString as NSString
        
        
        
        
        // Find matches for each regex pattern in the input string
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
        // Set default text font size to 15
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: attributedString.length))
        
        // Apply bold styling to text enclosed in **
        for result in boldResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: range)
        }
        // Apply italic styling to text enclosed in *
        for result in italicResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 15), range: range)
        }
        // Apply title styling to text prefixed with #
        for result in titleResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 23), range: range)
        }
        // Apply underline styling to text enclosed in <u></u>
        for result in underlineResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        // Apply highlight styling to text enclosed in ==
        for result in highlightResults.reversed() {
            let range = result.range(at: 1)
            attributedString.addAttribute(.backgroundColor, value: UIColor.darkGray, range: range)
        }
        // Apply list item styling and customization for text prefixed with -
        for result in listResults.reversed() {
            let range = result.range(at: 0) // Capture the range for the list item
            // Create a paragraph style to set line spacing
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 10 // Set the space between paragraphs
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            
            // Create a text attachment with a black dot (bullet point)
            let bulletPoint = "•\t"
            let bulletPointAttributedString = NSAttributedString(string: bulletPoint, attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.white
            ])
            
            // Replace the original "- " with the bullet point
            attributedString.replaceCharacters(in: NSRange(location: range.location, length: 2), with: bulletPointAttributedString)
            
            // Add a line break before each list item
            if range.location > 0 {
                attributedString.replaceCharacters(in: NSRange(location: range.location - 1, length: 1), with: "\n")
            }
        }
        // Apply URL link styling to text in [text](url) format
        for result in urlResults.reversed() {
            let textRange = result.range(at: 1)
            let urlRange = result.range(at: 2)
                    
            let linkText = nsString.substring(with: textRange)
            let url = nsString.substring(with: urlRange)
            
            let linkAttributedString = NSMutableAttributedString(string: linkText)
            linkAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: linkAttributedString.length))
            linkAttributedString.addAttribute(.link, value: url, range: NSRange(location: 0, length: linkAttributedString.length))
                    
            attributedString.replaceCharacters(in: result.range(at: 0), with: linkAttributedString)
        }
        // Apply dividing line styling for text ---
        for result in dividinglineResults.reversed() {
            let range = result.range(at: 0)
            // Add a horizontal line as a separator
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 2))
                        lineView.backgroundColor = UIColor.white
            let image = lineView.asImage()
            let attachment = NSTextAttachment()
            attachment.image = image
            let imageString = NSAttributedString(attachment: attachment)
            attributedString.replaceCharacters(in: range, with: imageString)
        }
        
                
        // Patterns to remove from the final string: '*', '# ', '<u>', '</u>', '=='
        let removePatterns = [
            "\\*",
            "# ",
            "<u>",
            "</u>",
            "=="]
        // Remove the unwanted characters used for markdown syntax
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

// Extension to convert a UIView to UIImage
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
