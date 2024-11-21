import PDFKit
import UIKit

class PDFGenerator {
    static func createPDF(from text: String) -> URL? {
        let pdfDocument = PDFDocument()

        // Create a single page with rendered text
        let pageBounds = CGRect(x: 0, y: 0, width: 612, height: 792) // A4 size
        let renderer = UIGraphicsImageRenderer(bounds: pageBounds)
        let pdfImage = renderer.image { context in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle
            ]
            
            text.draw(in: pageBounds.insetBy(dx: 20, dy: 20), withAttributes: attributes)
        }

        if let page = PDFPage(image: pdfImage) {
            pdfDocument.insert(page, at: 0)
        }

        // Save PDF to Documents directory
        let fileManager = FileManager.default
        let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("exam_preview.pdf")

        if pdfDocument.write(to: fileURL) {
            print("PDF successfully written to: \(fileURL)")
            return fileURL
        } else {
            print("Failed to write PDF to: \(fileURL)")
            return nil
        }
    }
}
