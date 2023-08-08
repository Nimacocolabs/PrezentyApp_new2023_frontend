
import 'package:event_app/screens/event/image_editor_screen.dart';
import 'package:flutter/material.dart';


final List<Template> birthdayTemplates = [
  // Template('assets/images/template/preview/t_birthday_preview_001.png', [
  //  Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xff010e1e), 100.0)),
  //   Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 5.72924637792062), 'assets/images/template/template_img_002.png', true, 100.0, 62.33534671034672, 0.0)),
  //   Layer(LayerType.Image,ImageProperties.image(false,Offset(1.9373820273441484, 6.329870676461585), 'assets/images/template/template_img_003.jpg', true, 51.890526890526885, 33.216455091455096, 0.0)),
  //   Layer(LayerType.Text,TextProperties.text(false,Offset(8.522727272727272, 85.54292929292929),'''On 2nd November''', 6.313131313131313, Color(0xbeffffff), Color(0x00000000), 'Parisienne', false, true, false, TextAlign.start, 0.0)),
  // ]),
  Template('assets/images/template/preview/t_birthday01.jpg', [
    Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
    Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/birthday01.jpeg', true, 100.0, 100.0, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(14.520202020202019, 38.19444444444445),'''1ST BIRTHDAY PARTY''', 6.318148371128504, Color(0xff0d6051), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(18.401154401153605, 50.541305916306236),'''OUR JOHNSON IS TURNING ONE!''', 5.05217740317078, Color(0xff07473a), Color(0x00000000), 'Cookie', true, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(31.579108533888196, 63.19868680870274),'''Feb 18, 2022  3:00 PM''', 4.41919191919192, Color(0xff000000), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(32.48089064815731, 74.36935787813535),'''Bradbury Residence
4468 Thompson St..
Los Angeles, CA 90017''', 4.41919191919192, Color(0xff000000), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.center, 0.0)),
  ]),
  Template('assets/images/template/preview/t_birthday02.jpg', [
    Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
    Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/birthday02.jpeg', true, 100.0, 100.0, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(31.663629654456116, 12.21503822399014),'''It's
Betsy's
Birthday!''', 7.57182428608693, Color(0xff5d4607), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(27.08973767589047, 44.03919216922738),'''Celebrate with us!''', 9.08704028139698, Color(0xff412908), Color(0x00000000), 'Cookie', false, false, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(32.05530870212369, 63.349191951480975),'''Saturday, May 5th
7:30 at Felix's
818 1st Street''', 6.4354122896043915, Color(0xff412908), Color(0x00000000), 'Cookie', false, false, false, TextAlign.center, 0.0)),
  ]),
  Template('assets/images/template/preview/t_birthday03.jpg', [
    Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
    Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/birthday03.jpeg', true, 100.0, 100.0, 0.0)),
    Layer(LayerType.Text,TextProperties.text(true,Offset(14.854056701644677, 34.68309504916189),'''YOU ARE INVITED TO


BIRTHDAY PARTY''', 6.62481428901815, Color(0xffffffff), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(25.968157422426003, 42.24309890398029),'''Riana Johns''', 9.276442280810736, Color(0xffffffff), Color(0x00000000), 'Pacifico', true, false, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(38.876997434183295, 72.34292393893813),'''21 DEC 2021
starts at  7pm''', 4.3519902960530725, Color(0xfff9f9f9), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.center, 0.0)),
  ]),
  Template('assets/images/template/preview/t_birthday04.jpg', [
    Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
    Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/birthday04.jpeg', true, 100.0, 100.0, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(61.05303449057955, 40.05113722364655),'''71st
Birthday''', 5.109598293708098, Color(0xff0d8905), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(true,Offset(31.969710639350463, 56.99316691558934),'''CELEBRATION HONOURING''', 4.920196294294342, Color(0xff28671b), Color(0x00000000), 'DancingScript', false, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(46.9608604705749, 66.74039980179015),'''Name''', 9.08704028139698, Color(0xff1b821c), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(39.39840645304351, 82.19068064327821),'''Dec 5, 2021 3pm-6pm''', 3.9731862972255603, Color(0xff457436), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
  ]),
  Template('assets/images/template/preview/t_birthday05.jpg', [
    Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
    Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/birthday05.jpeg', true, 100.0, 100.0, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(5.484532828282876, 13.691603535353453),'''BIRTHDAY''', 6.3529965604319045, Color(0xff269ee0), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(29.395517676767923, 27.817234848484834),'''PARTY''', 6.629241408336235, Color(0xff0e6365), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(7.220643939393923, 46.20422979797992),'''CELEBRATE WITH US!''', 4.419282625101591, Color(0xff345987), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.start, 0.0)),
    Layer(LayerType.Text,TextProperties.text(false,Offset(7.85195707070707, 66.72190656565645),'''Dec 2nd @ 8pm
1602 Hill Street. Apt,154''', 3.866792929292929, Color(0xff9b5e12), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.start, 0.0)),
  ]),
];

final List<Template> weddingTemplates =[
  Template(
      'assets/images/template/preview/t_wedding_preview_002.png',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/template_img_006.jpg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(43.50646578452806, 79.72050749442778),'''reception to follow''', 3.9731862972255603, Color(0xff000000), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.04055607657548, 67.04117162999779),'''Taj International''', 4.162588296639316, Color(0xff000000), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(38.162897222421485, 60.74888309971867),'''10 o'clock in the morning''', 4.3519902960530725, Color(0xff000000), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(33.386594548144075, 54.976719025183705),'''Saturday september 16th, 2021''', 4.162588296639316, Color(0xff000000), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.32411035759887, 34.39577794210482),'''and''', 4.730794294880585, Color(0xff000000), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(5.580619383941993, 15.803232111714124),'''you are cordially invited to the wedding of''', 4.730794294880585, Color(0xff000000), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(29.272426207634627, 25.59627614576703),'''Name''', 5.867206291363123, Color(0xff000000), Color(0x00000000), 'DancingScript', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(47.90419490838595, 43.100940520790495),'''Name''', 5.867206291363123, Color(0xff000000), Color(0x00000000), 'DancingScript', false, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_wedding_preview_001.png',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/template_img_001.jpg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.276875725523865, 17.032587714493257),'''Sarah''', 7.57182428608693, Color(0xffffffff), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(59.49015268547958, 26.447444375265793),'''and''', 4.162588296639316, Color(0xffffffff), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(65.73234989561804, 31.84094947170128),'''Austin''', 7.57182428608693, Color(0xffffffff), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.50076288865367, 60.512174208733235),'''SATURDAY | SEPTEMBER 21 | 2021
SIX O'CLOCK IN THE EVENING

add place here..''', 3.404980298984291, Color(0xffffffff), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(37.97396736388852, 48.49578240378327),'''WOULD LOVE YOUR PRESENCE IN
CELEBRATING THEIR MARRIAGE''', 3.404980298984291, Color(0xffffffff), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(49.7958911244165, 84.7353839569472),'''RECEPTION TO FOLLOW''', 2.6473723013292663, Color(0xffffffff), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_marriage01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/marriage01.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(18.347537878787747, 10.771780303029965),'''TOGETHER
WITH THEIR FAMILIES                ''', 4.971772320910252, Color(0xffc38327), Color(0x00000000), 'Cookie', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(41.153724747475124, 27.580492424242507),'''ERLIN''', 5.524262016718913, Color(0xffa06025), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(49.08459595959596, 36.30050505050499),'''&''', 3.866792929292929, Color(0xffc1902b), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.96874999999973, 43.91571969696957),'''JOHN''', 5.523989898989899, Color(0xffa66215), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(28.05397727272737, 55.358270202020186),'''Invite you to celebrate''', 3.866792929292929, Color(0xffa4784c), Color(0x00000000), 'serif', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.41635101010097, 66.40624999999993),'''Jun 15 2022''', 4.695527473005921, Color(0xffce9d5b), Color(0x00000000), 'Cookie', true, true, false, TextAlign.start, 0.0)),]
  ),
  Template(
      'assets/images/template/preview/t_marriage03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0,0), 'assets'
            '/images/template/marriage03.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(25.094696969697157, 16.57196969696976),'''we request your gracious 
presence in the wedding 
occasion of our daughter''', 3.866792929292929, Color(0xffcfa95b), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(40.8775252525253, 37.08964646464653),'''Name ''', 4.695527473005921, Color(0xffc2912a), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(45.9674873737374, 44.0735479797983),'''&''', 3.866792929292929, Color(0xffc58d52), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(41.35101010101004, 50.50505050505085),'''Name''', 4.695527473005921, Color(0xffc29652), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(45.69128787878787, 60.68497474747476),'''On''', 3.866792929292929, Color(0xffc9ab60), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(40.048926767676754, 64.51231060606062),'''S u n d a y''', 3.866792929292929, Color(0xffb39647), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(38.35227272727249, 70.07575757575766),'''05 Dec 2021''', 3.866792929292929, Color(0xffb08327), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(34.958964646464565, 76.62563131313124),'''St.Francis Church''', 3.866792929292929, Color(0xffa87b2b), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.start, 0.0)),]
  ),
  Template(
      'assets/images/template/preview/t_marriage02.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/marriage02.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(28.014520202020243, 16.808712121212114),'''JOIN US IN CELEBRATING
OUR WEDDING''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'Cookie', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(39.77272727272709, 28.093434343434392),'''Name''', 5.523989898989899, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(45.9280303030304, 35.3535353535354),'''of''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(40.167297979797894, 40.16729797979809),'''Name''', 5.523989898989899, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(24.423926767677, 60.093118686868664),'''Saturday, 10th of October
4 PM at the San Pablo Club
Dinner and dancing to folow''', 4.695527473005921, Color(0xff000000), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.center, 0.0)),]
  ),
];

final List<Template> saveTheDateTemplates =[
  Template(
      'assets/images/template/preview/t_savethedate_preview_001.png',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0,0), 'assets/images/template/template_img_005.jpg', true, 100, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(15.416748669337071, 73.55992743576108),'''Save the date''', 8.140030284328198, Color(0xffffffff), Color(0x00000000), 'Satisfy', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(15.065365490588311, 84.6562124192715),'''1.jan.2022''', 6.62481428901815, Color(0xffffffff), Color(0x00000000), 'Parisienne', false, false, false, TextAlign.start, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_sd01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/sd01.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(3.630050505050512, 21.78030303030326),'''Save The Date''', 8.01046564785789, Color(0xff998e8e), Color(0x00000000), 'KaushanScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(14.559659090909124, 51.64930555555549),'''Jane ''', 4.419282625101591, Color(0xff3e646b), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(19.0972222222223, 58.396464646463954),'''&''', 3.866792929292929, Color(0xff426459), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(15.427714646464729, 64.67013888888869),'''Andy''', 4.419282625101591, Color(0xff4f7581), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(49.67645202020167, 73.03503787878776),'''Are getting married 
Please save the date''', 4.143037777197259, Color(0xff5e9f80), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(12.547348484848591, 38.11553030303027),'''On 1st Dec 2021''', 3.866792929292929, Color(0xff73817d), Color(0x00000000), 'GreatVibes', true, true, false, TextAlign.start, 0.0)),]
  ),
  Template(
      'assets/images/template/preview/t_sd02.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.05449011500728074, -0.03269406900437018), 'assets/images/template/sd02.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(34.48547979797909, 7.181186868686955),'''Save The Date''', 6.905486256240567, Color(0xfffdfdfd), Color(0x64170303), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(50.66287878787833, 52.39898989898995),'''Anne''', 5.524262016718913, Color(0xff71450a), Color(0x00a39191), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(57.488952020201666, 59.38289141414147),'''&''', 3.866792929292929, Color(0xff8b7114), Color(0x00000000), 'serif', false, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(51.6493055555551, 63.80208333333333),'''Peter''', 5.248017168814582, Color(0xff5d4517), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(51.2152777777776, 87.6736111111112),'''On 28th Dec 2021''', 3.866792929292929, Color(0xff655410), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),]
  ),
  Template(
      'assets/images/template/preview/t_sd03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(5.420457754493389e-14, 2.1681831017973555e-13), 'assets/images/template/sd03.png', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.734532828282774, 32.63099747474773),'''Save The Date''', 5.248017168814582, Color(0xff3b6233), Color(0x00000000), 'GreatVibes', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(45.45454545454545, 46.24368686868684),'''Name''', 4.419282625101591, Color(0xff1a5922), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(51.136363636363654, 52.08333333333294),'''&''', 3.866792929292929, Color(0xff284024), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(45.45454545454528, 56.18686868686811),'''Name''', 4.695527473005921, Color(0xff355f2f), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(43.166035353535264, 68.89204545454561),'''Dec 23, 2021
11:00 AM''', 3.866792929292929, Color(0xff2d5532), Color(0x00000000), 'Cookie', true, false, false, TextAlign.center, 0.0)),]
  ),
  Template(
      'assets/images/template/preview/t_sd04.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/sd04.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.773989898989726, 34.090909090909584),'''HOSTED BY''', 3.866792929292929, Color(0xffb0b191), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(31.762941919191977, 42.33743686868689),'''JADA  &  WILL''', 4.419282625101591, Color(0xffa9a360), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(10.850694444444402, 53.306502525252675),'''We kindly ask that you save the 
date for the wedding of Jada Lee
and William Robertson. Full invitation 
to follow''', 3.866792929292929, Color(0xffb3a076), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(33.93308080808078, 82.2285353535354),'''Dec 10, 2021''', 3.866792929292929, Color(0xffc8a86b), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),]
  ),
];

final List<Template> baptismTemplates = [
  Template(
      'assets/images/template/preview/t_bap02.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/bap02.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(2.1813638409624314, 4.228290190751604),'''You are invited..''', 5.488402292535611, Color(0xff6e9a53), Color(0x00000000), 'serif', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(55.524310408958755, 48.60268336428098),'''Baptism
of''', 7.761226285500686, Color(0xff3456db), Color(0x00000000), 'Cookie', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(58.315445691346866, 69.28812334328482),'''Name''', 8.140030284328198, Color(0xffff0000), Color(0x00000000), 'Cookie', false, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_bap01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/bap01.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(30.743643176052238, 57.88114931424767),'''BABY AVA'S''', 7.193020287259416, Color(0xfff37b7b), Color(0x00000000), 'KaushanScript', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(34.76318709407115, 72.54757832387473),'''CHRISTENING''', 5.109598293708098, Color(0xffa67474), Color(0x00000000), 'Helvetica', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(25.21042225229281, 84.53625994494901),'''Dec 24, 2021 :  10 A.M''', 5.109598293708098, Color(0xffc6b2b2), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
      ]),
  Template(
      'assets/images/template/preview/t_bap03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/bap03.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(35.18401350487394, 30.690651115271862),'''Please join us for
the christening
of''', 5.299000293121854, Color(0xff374495), Color(0x00000000), 'Satisfy', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(33.58000824416624, 55.80918086407257),'''Jazmine Audrey''', 5.677804291949367, Color(0xff374fa6), Color(0x00000000), 'KaushanScript', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.32174022002329, 69.2849132317036),'''Sunday Dec 15, 11AM''', 3.404980298984291, Color(0xff40519f), Color(0x00000000), 'KaushanScript', false, false, false, TextAlign.center, 0.0)),
      ]),
  Template(
      'assets/images/template/preview/t_bap04.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/bap04.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(26.06260934704345, 20.70567292942664),'''CELEBRATE THE''', 6.05660829077688, Color(0xff3a5184), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(34.94929518560307, 29.53178481854431),'''Baptism''', 11.738668273189568, Color(0xff384d83), Color(0x00000000), 'DancingScript', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(47.904557243666865, 46.508252332833656),'''of''', 6.4354122896043915, Color(0xff3b3e88), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(24.119919332010333, 58.26538773422888),'''ALLISON PERRY''', 6.4354122896043915, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(26.295340159496654, 72.2225725921717),'''Mar 15, 2021 - 10:00 AM''', 4.541392295466829, Color(0xff000000), Color(0x00000000), 'Helvetica', true, false, false, TextAlign.center, 0.0)),
      ]),
  Template(
      'assets/images/template/preview/t_bap05.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/bap05.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(54.38900194413699, 18.33958449795257),'''Baptism''', 6.05660829077688, Color(0xffecba19), Color(0x00000000), 'Satisfy', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(24.25962705165147, 39.88405918194489),'''Sarah & Matt Smith invite you
Baptism of their daughter''', 3.594382298398048, Color(0xffad924c), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(26.248928950398447, 54.05872200158577),'''Grace Jones''', 7.950628284914442, Color(0xffebb952), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(31.072442414892304, 71.13606845655232),'''December 24th, 2021
St.Francis Church''', 3.9731862972255603, Color(0xffa6977c), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
      ]),
];
final List<Template> engagementTemplates = [
  Template(
      'assets/images/template/preview/t_eng01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.01796262768335407, 0), 'assets/images/template/Eng01.png', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(28.23246033354239, 28.53063527833357),'''ENGAGEMENT''', 8.708236282569468, Color(0xffb23b80), Color(0x00000000), 'Akronim', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(47.43136143819851, 38.93767788328925),'''of''', 7.193020287259416, Color(0xffb23b80), Color(0x00000000), 'KaushanScript', false, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(35.7987016947432, 55.403440970589116),'''Alan & Sam''', 6.4354122896043915, Color(0xffb23b80), Color(0x00000000), 'DancingScript', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.04252190897586, 68.74267550751401),'''14 DEC 2021''', 2.8367743007430226, Color(0xffb23b80), Color(0x00000000), 'KaushanScript', false, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_eng02.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/Eng02.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(28.758462779514325, 19.13988037600894),'''You are invited 
to the engagement party
of''', 4.920196294294342, Color(0xff000000), Color(0x00000000), 'Parisienne', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(29.56307241388336, 42.424819102825495),'''Name''', 7.57182428608693, Color(0xff000000), Color(0x00000000), 'DancingScript', false, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(43.79613340945972, 52.33463892650221),'''and''', 3.594382298398048, Color(0xff000000), Color(0x00000000), 'serif', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(50.60103559194011, 56.02908989371041),'''Name''', 7.57182428608693, Color(0xff000000), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.17591482158971, 71.69225391310133),'''Dec 24th 2021''', 3.404980298984291, Color(0xff000000), Color(0x00000000), 'Parisienne', false, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_eng03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/Eng03.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(26.38963475833024, 17.638300580347792),'''Engagement Ceremony''', 3.9731862972255603, Color(0xff2a4d0a), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(41.85280113909075, 27.553333841748096),'''Name''', 5.488402292535611, Color(0xff14550a), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(48.6629216644865, 35.99384547566841),'''&''', 5.109598293708098, Color(0xff579460), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.70284123380083, 43.69240060555074),'''Name''', 5.488402292535611, Color(0xff095926), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(46.67533168738546, 60.74975261634008),'''Venue''', 4.3519902960530725, Color(0xff124b23), Color(0x00000000), 'Cookie', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(30.787719715144064, 74.2706363861054),'''Sunday 20 December, 2021
06:00 pm onwards''', 4.920196294294342, Color(0xff0b6a15), Color(0x00000000), 'Cookie', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(29.934172196821635, 66.70924100008898),'''St.Francis church, Trivandrum''', 4.920196294294342, Color(0xff3c702c), Color(0x00000000), 'Cookie', false, false, false, TextAlign.start, 0.0)),
      ]),
  Template(
      'assets/images/template/preview/t_eng04.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/Eng04.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(31.40158481024612, 28.39868399970486),'''You are invited!''', 5.109598293708098, Color(0xff000000), Color(0x00000000), 'Cookie', true, false, false, TextAlign.start, 1.9333333333333333)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.78657672516516, 49.50403499153428),'''Name ''', 5.109598293708098, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 1.9333333333333333)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(43.992040378351675, 44.60066034992038),'''&''', 4.162588296639316, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 1.9277777777777778)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.676717853967205, 38.07193062998711),'''Name''', 5.109598293708098, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 1.9333333333333333)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.98695436294231, 59.969427987901845),'''Engagement on
Dec 23 2021
4:00 PM''', 4.541392295466829, Color(0xff000000), Color(0x00000000), 'Cookie', true, false, false, TextAlign.center, 1.9333333333333333)),
      ]),
  Template(
      'assets/images/template/preview/t_eng05.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/Eng05.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(32.72798064264044, 22.773017726451943),'''Engagement Party''', 3.7837842978118035, Color(0xff6e5f30), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(43.17846179192362, 32.94380787314955),'''Name''', 4.920196294294342, Color(0xff583c12), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(49.18433068334699, 39.23653766406467),'''&''', 5.299000293121854, Color(0xffa58822), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(43.36953431561336, 45.76046751342852),'''Name''', 4.920196294294342, Color(0xff6b4d0e), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(22.752589553207958, 56.91181362991165),'''Venue''', 4.541392295466829, Color(0xff54350a), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(37.549168106894534, 76.5939096755213),'''You are invited!''', 4.162588296639316, Color(0xff503908), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(26.76602662964296, 62.97222653573191),'''Sunday 20 Dec 2021
6:00 pm''', 3.7837842978118035, Color(0xff6d4f2d), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.start, 0.0)),
      ]),
];
final List<Template> cEventTemplates = [
  Template(
      'assets/images/template/preview/t_cor03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/cor03.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(25.773941977844654, 23.87421876385645),'''Annual Day''', 11.549266273775812, Color(0xfff9f9f9), Color(0x00000000), 'Satisfy', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(17.075901742879278, 48.21627886187036),'''Welcome you all for our annual day party 
on ''', 4.3519902960530725, Color(0xffffffff), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(30.69092661819678, 60.6536678631197),'''23rd Dec 2021 at Infopark''', 3.7819604304703804, Color(0xffffffff), Color(0x00000000), 'DancingScript', false, false, false, TextAlign.start, 0.0)),
      ]
  ),

  Template('assets/images/template/preview/t_cor06.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Text,TextProperties.text(true,Offset(28.373980894684713, 0.2847566861997615),'''Join''', 32.19408420987524, Color(0xff000000), Color(0x00000000), 'Cookie', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(56.321828118102204, 21.148695915260134),'''Us''', 30.678868214565195, Color(0xff000000), Color(0x00000000), 'Cookie', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(17.4029098146341, 56.443679044869754),'''For dinner and wine 
Austin Jacobs company is celebrating 
it's 25th year anniversary 
December 21st at 5 o'clock till late''', 3.7819604304703804, Color(0xff000000), Color(0x00000000), 'Helvetica', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(31.069476326758167, 80.1939144391906),'''The Palm Beach hotel
Dubai - UAE''', 3.7819604304703804, Color(0xff000000), Color(0x00000000), 'Helvetica', false, false, false, TextAlign.center, 0.0)),
      ]
  ),

  Template('assets/images/template/preview/t_cor05.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Text,TextProperties.text(true,Offset(49.087085168470026, 6.5307733010162945),'''Let's''', 29.542456218082663, Color(0xffa6972f), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.end, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(11.823004264045979, 28.010056557303226),'''Celebrate''', 29.353054218668905, Color(0xff928c2c), Color(0x00000000), 'GreatVibes', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(52.208179438656124, 64.29814283143415),'''At a retirement party for''', 3.2155782995705353, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(45.6346584822644, 70.77905994585971),'''Anderson Williams''', 4.541392295466829, Color(0xff000000), Color(0x00000000), 'serif', false, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(50.079630907963576, 80.19347968087949),'''August 20, 2021 at 5:30pm''', 3.2155782995705353, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(54.99777312983154, 85.25595834309392),'''The Loft at Union Pine
Poland, Oregon''', 3.2155782995705353, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.end, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_cor01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/cor01.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(18.54482323232324, 15.703914141414236),'''15th Annual
Office Dinner''', 8.28671049576222, Color(0xff9c711d), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(21.740845959595834, 46.046401515151295),'''City Hotel Ballroom
Aug 20, 2020  6:30pm''', 5.523989898989899, Color(0xffc5a46d), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(24.857954545454472, 72.67992424242398),'''All are invited!''', 6.0767517125275745, Color(0xffc7b887), Color(0x00000000), 'Parisienne', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_cor04.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/cor04.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(23.43749999999996, 20.438762626262434),'''PRODUCT LAUNCH
EVENT''', 4.971772320910252, Color(0xfff2e7e7), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(33.73579545454534, 8.32544191919194),'''you are invited!''', 5.523989898989899, Color(0xff927b58), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.10321969696963, 37.05018939393949),'''At
Country Club
123 Main Street
8:00 pm''', 3.866792929292929, Color(0xff97896c), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.center, 0.0)),
      ]
  ),
];
final List<Template> hCommunionTemplates = [
  Template(
      'assets/images/template/preview/t_commun01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/holy01.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(14.234570075165903, 23.309723760400516),'''First Holy Communion''', 7.57182428608693, Color(0xffd73131), Color(0x003e4aa9), 'DancingScript', false, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(23.408243872902577, 45.277127352627794),'''13 Aug 2021''', 4.3519902960530725, Color(0xffe43131), Color(0x00000000), 'Satisfy', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(16.931057093205414, 62.33485602635809),'''SIONA SHIBU''', 5.109598293708098, Color(0xffe5033d), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_holy02.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(1.9513647916176205e-14, -0.04359209200590785), 'assets/images/template/holy02.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(12.902462121212393, 18.11079545454556),'''Please join us to celebrate
1st Holy Communion
of''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(19.531250000000167, 55.516098484848506),'''On
Jan 12, 2021
at Saviour Church
11:00 AM''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(23.319128787878938, 38.47064393939403),'''Roshan
Manual''', 4.143037777197259, Color(0xff796c1e), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_holy03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/holy03.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(26.51515151515134, 31.407828282828206),'''Please join us as we celebrate''', 4.419282625101591, Color(0xffc493c2), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(26.909722222222243, 40.16729797979817),'''1st Holly Communion''', 3.866792929292929, Color(0xffd1a420), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.2215909090909, 46.32260101010109),'''of our daughter''', 4.419282625101591, Color(0xffba6fad), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(35.82702020202008, 58.238636363636466),'''JASMINE''', 4.971772320910252, Color(0xffc8a02d), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(33.065025252525054, 72.0486111111113),'''On Dec 24, 2021
At St.Francis Church
10 AM''', 3.866792929292929, Color(0xff9d4c8c), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_holy04.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/holy04.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(17.71622474747491, 27.659406565656585),'''PLRASE JOIN US AS WE  CELEBRATE''', 3.866792929292929, Color(0xff5b8186), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(26.949179292929255, 36.261047979797986),'''1st Holly communion''', 3.866792929292929, Color(0xffab8017), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(41.03535353535338, 43.402777777777715),'''of our son''', 5.248017168814582, Color(0xff33778a), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(40.127840909090914, 54.01672979797995),'''SAMUEL ''', 4.419282625101591, Color(0xff9c7410), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(35.11679292929301, 68.73421717171719),'''On Dec 23,  2021
St.Marys Church
10:00 AM''', 3.866792929292929, Color(0xff417c85), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_holy05.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/holy05.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.16856060606057, 10.022095959595982),'''First Communion''', 7.181731104144898, Color(0xffac8822), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.justify, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(41.86395202020182, 23.555871212121318),'''Join Us To Celebrate with''', 3.866792929292929, Color(0xff785210), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(52.83301767676796, 35.15625000000042),'''KATE''', 5.523989898989899, Color(0xff948648), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(48.01925505050507, 49.12405303030327),'''And her family
May 6th 11 am
1112 Twenty Drive
Orange Grove, FL''', 4.695527473005921, Color(0xff9b8431), Color(0x00000000), 'Cookie', true, false, false, TextAlign.center, 0.0)),
      ]
  ),

  Template(
      'assets/images/template/preview/t_holy06.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(false,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties. image(false,Offset(0.0, 0.0), 'assets/images/template/holy06.jpg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(40.00946969696973, 46.32260101010118),'''SAMUEL ''', 4.419282625101591, Color(0xff61c1d0), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(35.787563131313235, 62.14488636363641),'''On Dec 23,  2021
St.Marys Church
10:00 AM''', 3.895637408568443, Color(0xff4caab8), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_holy07.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(false,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties. image(false,Offset(0.0, 0.0), 'assets/images/template/holy07.jpg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(38.15498737373726, 61.82922979797999),'''ROSHAN''', 4.419282625101591, Color(0xff9c7410), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(35.94539141414149, 74.45549242424242),'''On Dec 23,  2021
St.Marys Church
10:00 AM''', 3.866792929292929, Color(0xfff5feff), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_holy08.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties. image(false,Offset(0.0, 0.0), 'assets/images/template/holy08.jpg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(57.92297979797977, 10.101010101009955),'''PLRASE JOIN US''', 3.866792929292929, Color(0xff5b8186), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(61.07954545454549, 22.41161616161642),'''1st 
Holly 
Communion
''', 3.3336235922442814, Color(0xffab8017), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(70.39141414141409, 39.4570707070707),'''of''', 5.248017168814582, Color(0xffcbbe72), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(65.18308080808087, 52.08333333333296),'''SARA''', 4.419282625101591, Color(0xff9c7410), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(15.822285353535342, 69.48390151515157),'''On Dec 23,  2021
St.Marys Church
10:00 AM''', 3.866792929292929, Color(0xff417c85), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_holy09.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties. image(false,Offset(0.0, 0.0), 'assets/images/template/holy09.jpg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(17.04545454545454, 11.2058080808082),'''PLRASE JOIN US AS WE  CELEBRATE''', 3.866792929292929, Color(0xff5b8186), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(27.146464646464658, 19.41287878787883),'''1st Holly communion''', 3.866792929292929, Color(0xffab8017), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(39.930555555555635, 64.70959595959539),'''SAMUEL ''', 4.419282625101591, Color(0xff9c7410), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.878787878787875, 75.59974747474747),'''On Dec 23,  2021
St.Marys Church
10:00 AM''', 3.3336235922442814, Color(0xffb09957), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
      ]
  ),

];
final List<Template> hWarmingTemplates = [
  Template(
      'assets/images/template/preview/t_house01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(true,Offset(0.0, 0.0), 'assets/images/template/house01.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(33.4407507750119, 11.252832359694757),'''Welcome''', 11.549266273775812, Color(0xff7dc2b9), Color(0x00000000), 'KaushanScript', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(20.860902006943657, 27.988256046718345),'''House warming''', 10.034050278465761, Color(0xff82d2d5), Color(0x00000000), 'KaushanScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(20.62242235330358, 46.530769792761035),'''13th Dec 2021''', 9.465844280224493, Color(0xff88b8d1), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_house02.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/house02.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(28.290719696969852, 28.29071969696973),'''House Warming''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(35.392992424242344, 36.49779040404052),'''PARTY''', 5.523989898989899, Color(0xffeb1316), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(32.03914141414142, 62.34217171717166),'''On Dec 23, 2021
4 PM''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'Cookie', true, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_house03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/house03.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(46.44097222222198, 10.14046717171722),'''You are Invited for the
House Warming 
PARTY''', 5.248017168814582, Color(0xff304708), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(57.80460858585854, 54.33238636363651),'''On
Dec 12, 2021
10:00 AM''', 3.866792929292929, Color(0xff0a1307), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_house04.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/house04.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(5.050505050505056, 38.983585858585926),'''You are invited!''', 4.143037777197259, Color(0xff02643d), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(3.43276515151525, 7.851957070706988),'''House Warming''', 4.971772320910252, Color(0xff770607), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(16.05902777777784, 20.478219696969767),'''PARTY''', 5.523989898989899, Color(0xff910000), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(8.049242424242466, 53.661616161616344),'''On
Dec 15, 2021
4:00 pm
Central Park West''', 3.866792929292929, Color(0xff0a2a17), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_house05.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/house05.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(21.50410353535363, 17.084911616161616),'''You  arr invited!''', 5.523989898989899, Color(0xffe11a1a), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(20.083648989899203, 27.97506313131305),'''House Warming''', 4.695527473005921, Color(0xff2ba4cd), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(31.17108585858599, 36.537247474747595),'''PARTY''', 5.523989898989899, Color(0xffed071a), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(25.56818181818189, 46.24368686868709),'''On
Dec 12, 2021,
4:00 PM
Central Park West''', 3.866792929292929, Color(0xff32a6bb), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
];

final List<Template> anniversaryTemplates = [
  Template(
      'assets/images/template/preview/t_anniversory01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/anniversory01.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(30.381944444444482, 12.547348484848364),'''JOIN  US  AS  WE
CELEBRATE  OUR''', 3.866792929292929, Color(0xff362b2b), Color(0x00000000), 'Tangerine', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(27.580492424242543, 26.00220959595975),'''50TH
ANNIVERSARY''', 5.248017168814582, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(28.093434343434154, 45.29671717171701),'''JOSH & ANA SMITH''', 3.866792929292929, Color(0xff481111), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.30050505050513, 56.97601010100992),'''Jun 15, 2022  6pm''', 4.143037777197259, Color(0xff000000), Color(0x00000000), 'Cookie', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(38.62847222222223, 67.03756313131343),'''405 Cross Street
Dublin
''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'Cookie', true, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_anniversory02.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/anniversory02.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(23.67424242424226, 14.362373737373831),'''YOU ARE INVITED TO THE''', 3.866792929292929, Color(0xff443636), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(39.93055555555566, 21.148989898990152),'''30th''', 8.28671049576222, Color(0xffa5771f), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(31.999684343434247, 33.577967171717184),'''ANNIVERSARY''', 4.143037777197259, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(34.288194444444386, 46.756628787878405),'''Jon  &  Alexis''', 4.143037777197259, Color(0xff926d10), Color(0x00000000), 'serif', false, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(31.486742424242394, 57.21275252525258),'''Saturday, Dec 24th
at 3pm''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(40.167297979798164, 39.53598484848499),'''in house of''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'DancingScript', true, false, false, TextAlign.start, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_anniversory03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/anniversory03.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(12.981376262626387, 14.717487373737448),'''LET'S CELEBRATE AARON & RINU'S''', 3.866792929292929, Color(0xff5c430c), Color(0x00000000), 'serif', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(29.434974747474968, 29.908459595959684),'''5th  Wedding
Anniversary''', 5.523989898989899, Color(0xff473612), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.286931818181785, 43.757891414141355),'''.................''', 5.523989898989899, Color(0xff5b5353), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(23.832070707070773, 60.13257575757541),'''JUNE  10,  2025  -  4:00 PM''', 3.866792929292929, Color(0xff63410a), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(25.962752525252686, 72.36426767676761),'''TWIN CANYON RESORT
FERMI CT, CORTLAND MANOR''', 3.866792929292929, Color(0xff4a3a13), Color(0x00000000), 'Cookie', true, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_anniversory04.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/anniversory04.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(31.40782828282807, 26.51515151515183),'''Please join us
for dinner and dancing
in celebration of the
Silver Wedding Anniversary
of''', 4.971772320910252, Color(0xff554f4f), Color(0x00000000), 'Tangerine', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(35.82702020202, 57.44949494949504),'''Donna & Steve''', 3.866792929292929, Color(0xff341d1d), Color(0x00000000), 'serif', true, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.77398989899007, 65.49873737373758),'''Saturday, Dec 12, 2021
Evening 6pm
5001 Curry Road
Pittsburgh, Pennsylvania''', 4.419282625101591, Color(0xff797676), Color(0x00000000), 'Tangerine', false, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_anniversary05.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/anniversary05.png', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(32.078598484848555, 10.77178030303024),'''Celebrating
growing together in love''', 3.866792929292929, Color(0xffa38327), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(25.647095959596093, 25.173611111111153),'''A N N I V E R S A R Y
D I N N E R''', 4.419282625101591, Color(0xff3a2e09), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(29.632260101009965, 40.838068181818585),'''honoring our parents''', 3.866792929292929, Color(0xffb3a070), Color(0x00000000), 'serif', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(32.63099747474741, 48.09816919191926),'''Sam & Kate''', 5.8005068646232445, Color(0xff706614), Color(0x00000000), 'KaushanScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(34.998421717171645, 61.513573232323395),'''Jan 8 at 6pm
Greenfield Country Club
110 Greenfield Way
Dearborn, Michigan''', 4.419282625101591, Color(0xff9a7d29), Color(0x00000000), 'Tangerine', true, false, false, TextAlign.center, 0.0)),
      ]
  ),

  Template('assets/images/template/preview/t_anniversary06.jpg',
      [

        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties. image(true,Offset(0.0, 0.0), ''
            'assets/images/template/anniversary06.jpg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(true,Offset(49.16351010101014, 36.37941919191932),'''LET'S CELEBRATE''', 3.895637408568443, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.92929292929307, 46.2436868686869),'''AARON & CHRISTINA'S''', 3.895637408568443, Color(0xff1b3285), Color(0x00000000), 'serif', false, true, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(53.18813131313159, 56.660353535353615),'''25th Wedding
Anniversary ''', 3.895637408568443, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(42.85037878787861, 71.25946969696973),'''JUNE 10, 2021  •  4:00 PM''', 3.895637408568443, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(39.85164141414158, 78.36174242424252),'''TWIN CANYON RESORT, NY''', 3.895637408568443, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
      ]),


];

final List<Template> jubileeTemplates = [
  Template(
      'assets/images/template/preview/t_jub01.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/jub01.png', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(19.21559343434343, 20.95170454545449),'''You are cordially invited to''', 4.419282625101591, Color(0xff000000), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(15.112058080808191, 31.052714646464807),'''25th  Ordination
Anniversary
Celebration Mass
for
Father Richard Cummings''', 4.971772320910252, Color(0xff3c3131), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(32.7493686868687, 70.15467171717195),'''Dec 14, 2021 4pm
St.Marys Church''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'Parisienne', true, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_jub02.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/jub02.png', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(25.647095959595887, 12.547348484848442),'''YOU ARE INVITED TO A''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(23.27967171717168, 22.648358585858585),'''50th  Anniversary''', 5.523989898989899, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(47.34848484848479, 32.19696969696963),'''of''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.103219696969624, 40.52241161616165),'''Ordination''', 5.523989898989899, Color(0xff000000), Color(0x00000000), 'Pacifico', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(33.617424242424114, 53.50378787878781),'''CELEBRATION''', 4.419282625101591, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(24.936868686868582, 65.65656565656577),'''FR. JAMES PATTERSON''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.87878787878773, 73.86363636363636),'''Honoring his 50 years
of service
to God''', 4.419282625101591, Color(0xff000000), Color(0x00000000), 'Tangerine', true, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_jub03.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/jub03.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(23.832070707070603, 12.784090909090876),'''Please join us for a
Mass and Celebration''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(27.06755050505031, 29.75063131313153),'''Fr. Joseph Neilly''', 6.0767517125275745, Color(0xff000000), Color(0x00000000), 'DancingScript', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(24.3844696969699, 43.955176767676946),'''Sunday, March 24, 2021
10:00 AM''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'serif', false, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(29.15877525252522, 62.93402777777777),'''Holy Trinity Church
123 West Main Street
Robinson, Pennsylvania''', 5.8005068646232445, Color(0xff000000), Color(0x00000000), 'Tangerine', false, false, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_jub04.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/jub04.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(36.53724747474741, 28.803661616161737),'''Fr. JOHN''', 5.248017168814582, Color(0xff664a0c), Color(0x00000000), 'serif', false, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(30.500315656565657, 36.65561868686867),'''35th Anniversary''', 7.734220799953557, Color(0xff967031), Color(0x00000000), 'Tangerine', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(44.981060606060524, 45.29671717171676),'''of''', 3.866792929292929, Color(0xff645414), Color(0x00000000), 'serif', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(34.84059343434354, 50.6234217171717),'''Ordination''', 8.83920019157088, Color(0xffa18122), Color(0x00000000), 'Tangerine', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(37.60258838383827, 64.27556818181813),'''you are invited!''', 3.866792929292929, Color(0xff2d2109), Color(0x00000000), 'Parisienne', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
  Template(
      'assets/images/template/preview/t_jub05.jpg',
      [
        Layer(LayerType.Canvas,CanvasProperties.canvas(true,Color(0xffffffff), 100.0 )),
        Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/jub05.jpeg', true, 100.0, 100.0, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(15.42771464646456, 21.740845959596015),'''Trinity United Reformed Church''', 3.866792929292929, Color(0xff6c571e), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(22.687815656565466, 31.210542929293194),'''Cordially invites you to the ''', 3.866792929292929, Color(0xff503a16), Color(0x00000000), 'serif', true, false, false, TextAlign.start, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(28.843118686868678, 38.78630050505071),'''Ordination Service''', 3.866792929292929, Color(0xff422e10), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(46.55934343434325, 45.77020202020201),'''for''', 3.866792929292929, Color(0xff46350c), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(14.638573232323319, 53.779987373737434),'''Napolean "Nollie" Malabuyo''', 4.419282625101591, Color(0xff7e571a), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
        Layer(LayerType.Text,TextProperties.text(false,Offset(30.65814393939381, 65.69602272727265),'''Friday, May 9th, 2022 at 7pm
Trinity United Reformed Church''', 3.866792929292929, Color(0xff794e1d), Color(0x00000000), 'Tangerine', true, true, false, TextAlign.center, 0.0)),
      ]
  ),
];


// final List<Template> charityTemplates = [
//   Template(
//       'assets/images/template/preview/t_charity_1.png',
//       [
//         Layer(LayerType.Canvas,CanvasProperties.canvas(false,Color(0xffffffff), 100.0 )),
//         //Layer(LayerType.Image,ImageProperties.image(false,Offset(0.0, 0.0), 'assets/images/template/jub01.png', true, 100.0, 100.0, 0.0)),
//         Layer(LayerType.Text,TextProperties.text(false,Offset(19.21559343434343, 20.95170454545449),'''You are cordially invited to''', 4.419282625101591, Color(0xff000000), Color(0x00000000), 'serif', true, false, false, TextAlign.center, 0.0)),
//         Layer(LayerType.Text,TextProperties.text(false,Offset(15.112058080808191, 31.052714646464807),'''Our Charity Event For Orphans''', 4.971772320910252, Color(0xff3c3131), Color(0x00000000), 'serif', true, true, false, TextAlign.center, 0.0)),
//         Layer(LayerType.Text,TextProperties.text(false,Offset(32.7493686868687, 70.15467171717195),'''Dec 14, 2021 4pm
// St.Marys Church''', 3.866792929292929, Color(0xff000000), Color(0x00000000), 'Parisienne', true, false, false, TextAlign.center, 0.0)),
//       ]
//   ),
//
// ];

final List<TemplateCategory> templateList = [
  // TemplateCategory('Charity','assets/images/event_categories/ic_jubilee.png',charityTemplates),
  TemplateCategory('Birthday','assets/images/event_categories/ic_birthday.png',birthdayTemplates),
  TemplateCategory('Wedding','assets/images/event_categories/ic_marriage.png',weddingTemplates),
  TemplateCategory('Save The Date','assets/images/event_categories/ic_save_the_date.png',saveTheDateTemplates),
  TemplateCategory('Baptism','assets/images/event_categories/ic_baptism.png',baptismTemplates),
  TemplateCategory('Engagement','assets/images/event_categories/ic_engagement.png',engagementTemplates),
  TemplateCategory('Corporate Event','assets/images/event_categories/ic_event.png',cEventTemplates),
  TemplateCategory('Holy Communion','assets/images/event_categories/ic_holy_communion.png',hCommunionTemplates),
  TemplateCategory('House Warming','assets/images/event_categories/ic_house_warming.png',hWarmingTemplates),
  TemplateCategory('Anniversary','assets/images/event_categories/ic_anniversary.png',anniversaryTemplates),
  TemplateCategory('Jubilee Celebration','assets/images/event_categories/ic_jubilee.png',jubileeTemplates),

];
