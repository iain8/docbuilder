kit = PDFKit.new(html, :page_size => Letter)

pdf = kit.to_pdf

file = kit.to_file('./doc.pdf')
