import os
from lxml import etree
import weasyprint
import argparse

def generate_pdf(xml_file, xslt_file, output_pdf):
    """
    Transform XML to HTML using XSLT and then convert to PDF
    
    Args:
        xml_file (str): Path to the XML file
        xslt_file (str): Path to the XSLT stylesheet
        output_pdf (str): Path for the output PDF file
    """
    print(f"Reading XML from {xml_file}")
    print(f"Using XSLT from {xslt_file}")
    
    # Parse the XML and XSLT files
    try:
        xml_doc = etree.parse(xml_file)
        xslt_doc = etree.parse(xslt_file)
        
        # Create a transformer from the XSLT
        transformer = etree.XSLT(xslt_doc)
        
        # Transform the XML using the XSLT
        print("Transforming XML to HTML...")
        result_html = transformer(xml_doc)
        
        # Convert the result to a string
        html_content = etree.tostring(result_html, pretty_print=True, encoding='utf-8')
        
        # Create a temporary HTML file to render
        temp_html_file = output_pdf.replace('.pdf', '.html')
        with open(temp_html_file, 'wb') as f:
            f.write(html_content)
        
        print(f"Temporary HTML file written to {temp_html_file}")
        
        # Convert HTML to PDF
        print("Converting HTML to PDF...")
        pdf = weasyprint.HTML(filename=temp_html_file).write_pdf()
        
        # Write the PDF to file
        with open(output_pdf, 'wb') as f:
            f.write(pdf)
        
        print(f"PDF successfully generated at {output_pdf}")
        
        # Optionally remove the temporary HTML file
        # Uncomment the line below if you want to delete the HTML
        # os.remove(temp_html_file)
        
    except Exception as e:
        print(f"Error: {str(e)}")
        raise

def main():
    parser = argparse.ArgumentParser(description='Generate PDF from XML using XSLT')
    parser.add_argument('--xml', required=True, help='Path to the XML file')
    parser.add_argument('--xslt', required=True, help='Path to the XSLT stylesheet')
    parser.add_argument('--output', required=True, help='Path for the output PDF file')
    
    args = parser.parse_args()
    
    generate_pdf(args.xml, args.xslt, args.output)

if __name__ == "__main__":
    main()
