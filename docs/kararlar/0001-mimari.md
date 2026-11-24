# 0001 Mimari: batch, streaming ve tablo formatı

Durum: Önerildi
Tarih: 23 Kasım 2026

## Bağlam

İstanbul Mobilite Veri Platformu, toplu ulaşım ve trafik
yoğunluğu verilerini işlemek üzere tasarlanmaktadır.
Aylık CSV dosyaları raporlama amacıyla kullanılırken,
kart geçiş olayları durak yoğunluğunun izlenmesinde
kullanılacaktır.

Aylık raporlar için bir günlük gecikme kabul edilebilirken,
durak yoğunluğu verilerinin en geç 5 dakika içerisinde
güncellenmesi gerekmektedir.

## Karar

Aylık CSV dosyaları batch yöntemiyle bronze, silver ve
gold katmanlarında işlenecek, geçiş olayları Kafka ve
Structured Streaming ile aktarılacak, açık tablo formatı
olarak Apache Iceberg ve katalog olarak Apache Polaris
kullanılacaktır.

## Gerekçe

- Aylık raporların bir günlük gecikme toleransı batch
  işlemeyi desteklemektedir.
- Durak yoğunluğunun 5 dakikalık gecikme hedefi streaming
  yaklaşımını gerektirmektedir.
- DuckDB ve Spark ile aynı Iceberg tablosundaki
  34.241.461 kayıt başarıyla okunmuştur.
- İki snapshot oluşturulmuş ve ilk snapshot üzerinden
  17.283.355 Ocak kaydına erişilmiştir.
- Tüm verilerin streaming ile işlenmesi, aylık raporlar
  için gereksiz sürekli kaynak kullanımı oluşturacağından
  tercih edilmemiştir.
- Yalnızca batch kullanılması, 5 dakikalık güncelleme
  hedefini karşılamakta yetersiz kalabileceğinden
  tercih edilmemiştir.

## Sonuçlar

- Bronze katmanında ham veri değiştirilmeden saklanacaktır.
- Veri kalitesi ve tekilleştirme işlemleri silver
  katmanında gerçekleştirilecektir.
- Gold katmanında raporlama ve analiz için metrikler
  oluşturulacaktır.
- Streaming bileşenleri sürekli kaynak kullanımı ve
  izleme gerektirecektir.
- Veri kalitesi, şema değişiklikleri ve işlem hataları
  düzenli olarak kontrol edilecektir.
- Gerçek işletim maliyeti ve 5 dakikalık gecikme hedefinin
  sağlanıp sağlanmadığı sonraki oturumlarda sınanacaktır.
