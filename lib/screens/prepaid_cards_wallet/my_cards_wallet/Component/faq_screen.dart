import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  QAData qA = QAData();
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListView.builder(
            itemCount: qA.qA.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildQAWidget(qA.qA[index], false);
              // _buildQAWidget(showAnswer);
            }),
      ),
    );
  }

  Widget _buildQAWidget(Map qAData, bool showAnswerToggle) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Card(
          margin: EdgeInsets.all(8),
          child: Container(
            width: screenWidth,
            child: GestureDetector(
                onTap: () => setState(() {
                      showAnswerToggle = !showAnswer;
                    }),
                child: GFAccordion(
                  title:
                      qAData.keys.toString().split("(").last.split(")").first,
                  content:
                      qAData.values.toString().split("(").last.split(")").first,
                )),
          ),
        ),
      ],
    );
  }
}

class QAData {
  List<Map<String, String>> qA = [
    {
      """What are the benefits of Prezenty prepaid cards?""":
          """Prezenty prepaid cards is a lifetime card, with minimal setup fees. With one of the best rewards programs in India, Prezenty cards offers, a Rs. 500 welcome Gift, and more. In partnership with RBI-approved Livquik and Rupay, Prezenty card has a 99.8% acceptance rate, and can be used for purchasing anything, be it online or offline."""
    },
    {
      """How can I get Prezenty Card?""":
          """Just download the Prezenty app, complete your 2 min digital KYC, and you’re done! You will instantly get your virtual Prezenty card and you can start using it for online purchases. You also get a free physical card along with your virtual card."""
    },
    {
      """What makes Prezenty Card so special?""":
          """Lots of things, but here goes a few!
One card, for all –card for everyone!
Personalized and Trendy Quick, 
Paperless KYC,
A world of super rewards
99% acceptance all over India
Transparency without conditions"""
    },
    {
      """What are the benefits for Prezenty Card?""":
          """Fewer entry barriers for getting the prepaid card
Powered by VISA/Rupay. So the card can be used all over India at both online and offline stores.
Available in both physical and virtual form 
As long as you have KYC documents, you can easily get the Prezenty card
Get promotional offers after signing up. Also, get additional benefits /offers on every transaction
All operations related to the card can be directed by you using the Prezenty App
Get multiple rewards with every referral"""
    },
    {
      """Where can I use Prezenty card?""":
          """Fewer entry barriers for getting the prepaid card
Powered by VISA/Rupay. So the card can be used all over India at both online and offline stores.
Available in both physical and virtual form 
As long as you have KYC documents, you can easily get the Prezenty card
Get promotional offers after signing up. Also, get additional benefits /offers on every transaction
All operations related to the card can be directed by you using the Prezenty App
Get multiple rewards with every referral"""
    },
    {
      """Where can I use Prezenty card?""":
          """Wherever you want! Prezenty card can be used both online and offline. You can swipe it or tap it at a store, or punch in your card details during checkout. Every transaction earns offers/promotions by brands/merchants or Prezenty. For more details, check our T&C."""
    },
    {
      """Why do I need to verify my identity/Digital KYC?""":
          """In order to comply with the laws, we are required to gather certain information from our users in order to offer the use of a Livquik powered Wallet to receive and make payments. At this time, we need to verify your identity in order to offer the use of a Wallet. Verifying your identity helps ensure that a fraudster has not stolen your credentials (this protects you and your money) and helps prevents fraud and money laundering.  """
    },
    {
      """How can I complete the Digital KYC verification?""":
          """Just download the Prezenty app, complete your 2 min digital KYC, and you’re done! You will instantly get your virtual Prezenty card, and you can start using it for online purchases. You also get a free physical card along with your virtual card."""
    },
    {"""How can I verify the mobile number?""": """"""},
    {
      """I'm going to change my number and/or phone, what should I do?""":
          """In case you have changed your number, you can login with your old credentials and keep the old sim active on any other device to get the verification code in order to get access to your old account. In case you have changed your device, check for device compatibility.

How can I reset the Pin number of my Virtual card? 


How can I reset the Pin number of my physical card? 

Is it mandate to request the physical card?"""
    },
    {
      """How do I load the wallet/card from the bank account?""":
          """Once the prepaid virtual/physical card generated, you may load the wallet/account through net banking NEFT/IMPS/UPI through your bank account. 
Fund transfer/transaction charge may be applicable on NEFT/IMPS transfers that are initiated through digital modes of banking, i.e., Internet Banking, Mobile app /UPI. You may verify this with your banking provider/service provider. """
    },
    {
      """I can't find the money I transferred from bank account/card to Prezenty card. Where is it?""":
          """Prezenty works with Decentro & Livquik, a financial software provider, and partner bank, to provide banking services to our customers. Your card balance transfer will appear as "Balance" after the standard settlement time. If have any issues while loading the wallet, you may contact with us anytime at support@prezenty.in """
    },
    {
      """Why are bank transfer timelines dependent on business days?""":
          """Bank transfer timelines are dependent on the settlement time, Prezenty banking partner, and your bank. If you’ve already initiated a bank transfer, there’s no way for us to expedite that process."""
    },
    {
      """How much money I can load to the wallet in a day /Month or a Year?""":
          """"""
    },
    {
      """How do I use the card at offline stores?""":
          """To use the card at offline stores, you need to order a physical card for yourself which can be used to swipe or tap for payments. Also, it's quite cool to carry. """
    },
    {
      """Can I know where the card money was expended?""":
          """Yes, you can view the names of brands or registered names of merchants for transactions made with them. """
    },
    {
      """How many cards can I get with one account?""":
          """One physical card and two virtual cards. Also, It depends on the subscription package you have chosen."""
    },
    {
      """How do you keep my information secure?""":
          """At Prezenty, we take customer privacy and security seriously.
We use high-level security to keep your information safe. This includes physical, electronic and procedural measures designed to prevent unauthorized access to (and disclosure of) sensitive information. We use encryption and tokenization to help protect your account information and monitor your account activity to help identify unauthorized transactions. If you suspect that your account shows unauthorized activity, contact us right away at support@prezenty.in """
    },
  ];
}
