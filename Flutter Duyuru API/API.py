from flask import Flask, Response
import json
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)


@app.route('/duyurular', methods=['GET'])
def get_duyurular():
    url = 'https://www.osym.gov.tr/TR,29084/2024.html'  # ÖSYM duyurular sayfası
    response = requests.get(url)

    if response.status_code != 200:
        return Response(json.dumps({"message": "Web sitesine ulaşılamadı"}, ensure_ascii=False),
                        mimetype='application/json'), 500

    soup = BeautifulSoup(response.content, 'html.parser')

    duyurular = []
    # Tablo içindeki tüm <a> etiketlerini seç
    for item in soup.select('table#list a'):
        title = item.select_one('h2').text.strip()  # <h2> içindeki başlık
        link = item['href']  # Bağlantı
        # Bağlantıyı tam URL'ye çevir
        if not link.startswith('http'):
            link = f"https://www.osym.gov.tr{link}"
        duyurular.append({'title': title, 'link': link})

    # Eğer duyuru bulunamadıysa
    if not duyurular:
        return Response(json.dumps({"message": "Duyuru bulunamadı"}, ensure_ascii=False),
                        mimetype='application/json'), 404

    # Unicode karakterleri düzelt ve JSON döndür
    return Response(json.dumps(duyurular, ensure_ascii=False), mimetype='application/json')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)  # Sunucuyu çalıştır
