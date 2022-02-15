require 'bundler/setup'
require 'rqrcode'
require 'rqrcode_png'
require 'pdfkit'

class WiFi
  def initialize(ssid, pw)
    @ssid = ssid
    @pw = pw
  end

  def make_qrcode
    content = "WIFI:T:WPA;S:#{@ssid};P:#{@pw};;"

    qr = RQRCode::QRCode.new(content)
    qr.as_svg
  end

  def to_html
    ''"
      <div class='content'>
      #{make_qrcode}
      <p>SSID: #{@ssid}</p>
      <p>Password: #{@pw}<p>
      </div>
    "''
  end

  def save(name)
    kit = PDFKit.new(to_html)
    kit.stylesheets << './style.css'
    File.write(name, kit.to_pdf)
  end
end

ssid = ARGV[0]
pw = ARGV[1]

WiFi.new(ssid, pw).save('output.pdf')
