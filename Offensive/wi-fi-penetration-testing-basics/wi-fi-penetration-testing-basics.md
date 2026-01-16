# Wi-Fi Penetration Testing Basics Overview

---

In today's interconnected world, WiFi networks have become ubiquitous, serving as the backbone of our digital connectivity. However, with this convenience comes the risk of security vulnerabilities that can be exploited by malicious actors. WiFi pentesting, or penetration testing, is a crucial process employed by cybersecurity professionals to assess the security posture of WiFi networks. By systematically evaluating passphrases, configurations, infrastructure, and client devices, WiFi pentesters uncover potential weaknesses and vulnerabilities that could compromise network security. In this module, we'll explore the fundamental principles of WiFi pentesting, covering key aspects of the process and highlighting essential techniques used to assess and enhance the security of WiFi networks.

### Wi-Fi Authentication Types

WiFi authentication types are crucial for securing wireless networks and protecting data from unauthorized access. The main types include WEP, WPA, WPA2, and WPA3, each progressively enhancing security standards.

![Flowchart of WiFi Security showing authentication types: WEP, WPA, WPA2, and WPA3. WPA2 splits into Personal and Enterprise, with Enterprise further dividing into EAP-TTLS/PAP and PEAP-MSCHAPv2. WPA3 splits into Personal and Enterprise, with Enterprise leading to EAP-TLS, culminating in Certificate-Based Authentication (CBA).](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/Wifi_auth_types.png)

- `WEP (Wired Equivalent Privacy)`: The original WiFi security protocol, WEP, provides basic encryption but is now considered outdated and insecure due to vulnerabilities that make it easy to breach.
- `WPA (WiFi Protected Access)`: Introduced as an interim improvement over WEP, WPA offers better encryption through TKIP (Temporal Key Integrity Protocol), but it is still less secure than newer standards.
- `WPA2 (WiFi Protected Access II)`: A significant advancement over WPA, WPA2 uses AES (Advanced Encryption Standard) for robust security. It has been the standard for many years, providing strong protection for most networks.
- `WPA3 (WiFi Protected Access III)`: The latest standard, WPA3, enhances security with features like individualized data encryption and more robust password-based authentication, making it the most secure option currently available.

When we look to get started on our path of becoming wireless penetration testers, we should always consider the fundamental skills required for us to be successful. Knowing these skills can ensure that we do not get lost along the way when we are exploring many different authentication mechanisms and protections. After all, although wi-fi is one of the most available areas of perimeter security for our exploitation, it presents difficulty to even some of the most seasoned veterans.

A WiFi penetration test comprises the following four key components:

- Assessing passphrases for strength and security
- Analyzing configuration settings to identify vulnerabilities
- Probing the network infrastructure for weaknesses
- Testing client devices for potential security flaws

Let's delve into a detailed discussion of these four crucial components.

1. `Evaluating Passphrases`: This involves assessing the strength and security of WiFi network passwords or passphrases. Pentesters employ various techniques, such as dictionary attacks, brute force attacks, and password cracking tools, to evaluate the resilience of passphrases against unauthorized access.
2. `Evaluating Configuration`: Pentesters analyze the configuration settings of WiFi routers and access points to identify potential security vulnerabilities. This includes scrutinizing encryption protocols, authentication methods, network segmentation, and other configuration parameters to ensure they adhere to best security practices.
3. `Testing the Infrastructure`: This phase focuses on probing the robustness of the WiFi network infrastructure. Pentesters conduct comprehensive assessments to uncover weaknesses in network architecture, device configurations, firmware versions, and implementation flaws that could be exploited by attackers to compromise the network.
4. `Testing the Clients`: Pentesters evaluate the security posture of WiFi clients, such as laptops, smartphones, and IoT devices, that connect to the network. This involves testing for vulnerabilities in client software, operating systems, wireless drivers, and network stack implementations to identify potential entry points for attackers.

By systematically evaluating these aspects, pentesters can identify and mitigate security risks, strengthen defenses, and enhance the overall security posture of WiFi networks.

> Note: After spawning, please wait `3`-`4` minutes before connecting to the target(s).
# 802.11 Frames and Types

---

In order to understand 802.11 traffic better, we can dive into frame construction, types, and subtypes. In 802.11 communications, there are a few different frame types utilized for different actions. These actions are all a part of the connection cycle, and standard communications for these wireless networks. Many of our attacks utilize packet crafting/forging techniques. We look to forge these same frames to perform actions like disconnecting a client device from the network with a deauthentication/disassociation request.

#### The IEEE 802.11 MAC Frame

All 802.11 frames utilize the MAC frame. This frame is the foundation for all other fields and actions that are performed between the client and access point, and even in ad-hoc networks. The MAC data frame consists of 9 fields.

|Field|Description|
|---|---|
|Frame Control|This field contains tons of information such as type, subtype, protocol version, to ds (distribution system), from DS, Order, etcetera.|
|Duration/ID|This ID clarifies the amount of time in which the wireless medium is occupied.|
|Address 1, 2, 3, and 4|These fields clarify the MAC addresses involved in the communication, but they could mean different things depending on the origin of the frame. These tend to include the BSSID of the access point and the client MAC address, among others.|
|SC|The sequence control field allows additional capabilities to prevent duplicate frames.|
|Data|Simply put, this field is responsible for the data that is transmitted from the sender to the receiver.|
|CRC|The cyclic redundancy check contains a 32-bit checksum for error detection.|

#### IEEE 802.11 Frame Types

IEEE frames can be put into different categories for what they do and what actions they are involved in. Generally speaking, we have the following types among some others. These codes can help us when filtering Wireshark traffic.

1. `Management (00):` These frames are used for management and control, and allowing the access point and client to control the active connection.
2. `Control (01):` Control frames are used for managing the transmission and reception of data frames within wi-fi networks. We can consider them like a sense of quality control.
3. `Data (10):` Data frames are used to contain data for transmission.

#### Management Frame Sub-Types

Primarily, for wi-fi penetration testing, we focus on management frames. These frames after all are used to control the connection between the access point and client. As such we can dive into each one, and what they are responsible for.

If we look to filter them in Wireshark, we would specify type `00` and subtypes like the following.

1. `Beacon Frames (1000)`
2. `Probe Request (0100) and Probe Response (0101)`
3. `Authentication Request and Response (1011)`
4. `Association/Reassociation Request and Responses (0000, 0001, 0010, 0011)`
5. `Disassociation/Deauthentication (1010, 1100)`

#### 1. Beacon Frames

Beacon frames are primarily used by the access point to communicate its presence to the client or station. It includes information such as supported ciphers, authentication types, its SSID, and supported data rates among others.

#### 2. Probe Requests and Responses

The probe request and response process exist to allow the client to discover nearby access points. Simply put, if a network is hidden or not hidden, a client will send a probe request with the SSID of the access point. The access point will then respond with information about itself for the client.

#### 3. Authentication Request and Response

Authentication requests are sent by the client to the access point to begin the connection process. These frames are primarily used to identify the client to the access point.

#### 4. Association/Reassociation Requests

After sending an authentication request and undergoing the authentication process, the client sends an association request to the access point. The access point then responds with an association response to indicate whether the client is able to associate with it or not.

#### 5. Disassociation/Deauthentication Frames

Disassociation and Deauthentication frames are sent from the access point to the client. Similar to their inverse frames (association and authentication), they are designed to terminate the connection between the access point and the client. These frames additionally contain what is known as a reason code. This reason code indicates why the client is being disconnected from the access point. We utilize crafting these frames for many handshake captures and denial of service based attacks during wi-fi penetration testing efforts.

---

# The Connection Cycle

Now that IEEE 802.11 frame types and management frame sub-types have been reviewed, let's examine the typical connection process between clients and access points, known as the `connection cycle`. We will focus on basic WPA2 authentication, although this process may vary depending on the Wi-Fi standard in use. However, the general connection cycle follows this sequence.

1. `Beacon Frames`
2. `Probe Request and Response`
3. `Authentication Request and Response`
4. `Association Request and Response`
5. `Some form of handshake or other security mechanism`
6. `Disassociation/Deauthentication`

To better understand this process, the raw network traffic can be examined in Wireshark. After successfully capturing a valid handshake, the capture file can then be opened in Wireshark for detailed analysis.

Beacon frames from the access point can be identified using the following Wireshark filter:

`(wlan.fc.type == 0) && (wlan.fc.type_subtype == 8)`

![Wireshark capture showing multiple 802.11 Beacon frames from source 'Cisco-Li_82:b2:55' to 'Broadcast', with SSID 'Coherer'.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/001_beacon.PNG)

Probe request frames from the client can be identified using the following Wireshark filter:

`(wlan.fc.type == 0) && (wlan.fc.type_subtype == 4)`

![Wireshark capture showing 802.11 Probe Requests from source 'Apple_82:36:3a' to 'Broadcast', with SSID 'Coherer'.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/002_probe_request.PNG)

Probe response frames from the access point can be identified using the following Wireshark filter:

`(wlan.fc.type == 0) && (wlan.fc.type_subtype == 5)`

![Wireshark capture showing 802.11 Probe Responses from source 'Cisco-Li_82:b2:55' to destination 'Apple_82:36:3a', with SSID 'Coherer'.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/003_probe_response.PNG)

The authentication process between the client and the access point can be observed using the following Wireshark filter:

`(wlan.fc.type == 0) && (wlan.fc.type_subtype == 11)`

![Wireshark capture showing 802.11 Authentication frames between 'Apple_82:36:3a' and 'Cisco-Li_82:b2:55'.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/004_authentication.PNG)

After the authentication process is complete, the station's association request can be viewed using the following Wireshark filter:

`(wlan.fc.type == 0) && (wlan.fc.type_subtype == 0)`

![Wireshark capture showing 802.11 Association Response from 'Cisco-Li_82:b2:55' to 'Apple_82:36:3a', with SSID 'Coherer'.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/005_association_request.PNG)

The access point's association response can be viewed using the following Wireshark filter:

`(wlan.fc.type == 0) && (wlan.fc.type_subtype == 1)`

![Wireshark capture showing 802.11 Association Response from 'Cisco-Li_82:b2:55' to 'Apple_82:36:3a'.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/006_association_response.PNG)

If the example network uses WPA2, the EAPOL (handshake) frames can be viewed using the following Wireshark filter:

`eapol`

![Wireshark capture showing EAPOL key exchange between 'Cisco-Li_82:b2:55' and 'Apple_82:36:3a', with messages 1 to 4 of 4.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/007_handshake.PNG)

Once the connection process is complete, the termination of the connection can be viewed by identifying which party (client or access point) initiated the disconnection. This can be done using the following Wireshark filter to capture Disassociation frames (10) or Deauthentication frames (12).

`(wlan.fc.type == 0) && (wlan.fc.type_subtype == 12) or (wlan.fc.type_subtype == 10)`

![Wireshark capture showing 802.11 Disassociate frame from 'Apple_82:36:3a' to 'Cisco-Li_82:b2:55'.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/008_Disassociation.PNG)

Now that we know a little about the types of frames, in the next section, we will explore the different authentication methods and cover the basic connection cycle between the client and the access point.
# Authentication Methods

---

There are two primary authentication systems commonly used in WiFi networks: `Open System Authentication` and `Shared Key Authentication`.

![Flowchart of Authentication Methods: Open Key and Shared Key. Open Key includes WEP, which is obsolete and uses RC4 and CRC-32. Shared Key includes WPA, using TKIP and MIC, and 802.11i/WPA2, using AES and CCM.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/Auth_Methods/auth_methods_.png)

- `Open System Authentication` is straightforward and does not require any shared secret or credentials for initial access. This type of authentication is typically used in open networks where no password is needed, allowing any device to connect to the network without prior verification.
- `Shared Key Authentication`, as the name suggests, involves the use of a shared key. In this system, both the client and the access point verify each other's identities by computing a challenge-response mechanism based on the shared key.

While many other methods exist, especially in `Enterprise` environments or with advanced protocols like `WPA3` and `Enhanced Open`, these two are the most prevalent.

---

### Open System Authentication

As the name implies, open system authentication does not require any shared secret or credentials right away. This authentication type is commonly found for open networks that do not require a password. For Open System Authentication, it tends to follow this order:

1. The client (station) sends an authentication request to the access point to begin the authentication process.
2. The access point then sends the client back an authentication response, which indicates whether the authentication was accepted.
3. The client then sends the access point an association request.
4. The access point then responds with an association response to indicate whether the client can stay connected.

![Diagram showing communication between Client and AP: Authentication Request, Authentication Response, Association Request, and Association Response.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/Auth_Methods/Open_system.png)

As shown in the image above, Open System Authentication does not require any credentials or authentication. Devices can connect directly to the network without needing to enter a password, making it convenient for public or guest networks where ease of access is a priority.

While Open System Authentication is convenient for public or guest networks, Shared Key Authentication offers an additional layer of security by ensuring that only devices with the correct key can access the network.

---

### Shared Key Authentication

On the other hand shared key authentication does involve a shared key, as the name implies. In this authentication system, the client and access point prove their identities through the computation of a challenge. This method is often associated with Wired Equivalent Privacy (`WEP`) and Wi-Fi Protected Access (`WPA`). It provides a basic level of security through the use of a pre-shared key.

![Table of Shared Key Authentication Methods: WEP uses pre-shared key, RC4, CRC-32, and is weak. WPA uses PSK or 802.1x, TKIP, MIC, and is strong. 802.11i/WPA2 uses PSK or 802.1x, AES, CCMP, and is stronger.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/Auth_Methods/Shared_auth.png)

---

#### Authentication with WEP

1. `Authentication request:` Initially, as it goes, the client sends the access point an authentication request.
2. `Challenge:` The access point then responds with a custom authentication response which includes challenge text for the client.
3. `Challenge Response:` The client then responds with the encrypted challenge, which is encrypted with the WEP key.
4. `Verification:` The AP then decrypts this challenge and sends back either an indication of success or failure.

![Diagram showing communication between Client and AP: Authentication Request, Challenge, Challenge Response, and Confirm Success/Failure.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/Auth_Methods/Wep_process.png)

---

#### Authentication with WPA

On the flip side, WPA utilizes a form of authentication that includes a four-way handshake. Commonly, this replaces the association process with more verbose verification, and in the case of WPA3, the authentication portion is even crazier for the pairwise key generation. From a high level, this is performed like the following.

1. `Authentication Request:` The client sends an authentication request to the AP to initiate the authentication process.
2. `Authentication Response:` The AP responds with an authentication response, which indicates that it is ready to proceed with authentication.
3. `Pairwise Key Generation:` The client and the AP then calculate the PMK from the PSK (password).
4. `Four-Way Handshake:` The client and access point then undergo each step of the four way handshake, which involves nonce exchange, derivation, among other actions to verify that the client and AP truly know the PSK.

![Diagram showing communication between Client and AP: Authentication Request, Authentication Response, Pairwise Key Generation, and 4-Way Handshake.](https://cdn.services-k8s.prod.aws.htb.systems/content/modules/222/Auth_Methods/Wpa_process.png)

Shared key authentication type also involves [WPA3](https://documentation.meraki.com/MR/Wi-Fi_Basics_and_Best_Practices/WPA3_Encryption_and_Configuration_Guide), the latest and most secure WiFi security standard. WPA3 introduces significant improvements over its predecessors, including more robust encryption and enhanced protection against brute force attacks. One of its key features is `Simultaneous Authentication of Equals (SAE)`, which replaces the `Pre-Shared Key (PSK)` method used in WPA2, providing better protection for passwords and individual data sessions.

Despite its advantages, WPA3 adoption has been slower due to hardware restrictions. Many existing devices do not support WPA3 and require firmware updates or replacements to be compatible. This creates a barrier to widespread implementation, particularly in environments with a large number of legacy devices. Consequently, while WPA3 offers superior security, its use is not yet widespread, and many networks continue to rely on older standards like WPA2 until the necessary hardware upgrades become more accessible and affordable.

---

## Moving On

In this section, we discussed various authentication types. We explored their unique characteristics, security features, and the evolution of these protocols to address emerging threats.

In the next section, we will focus on WiFi interfaces. We will cover several important aspects, including how to:

- Adjust signal strength
- Change frequency and channel settings
- Modify region settings
- Check driver capabilities
- Scan for available WiFi networks

Understanding these elements will enable us to optimize and troubleshoot our wireless connections more effectively. This comprehensive approach will ensure that our networks operate smoothly and efficiently, meeting our specific needs and adapting to different environments.
# Wi-Fi Interfaces

---

Wireless interfaces are a cornerstone of wi-fi penetration testing. After all, our machines transmit and receive this data through these interfaces. If we didn't have them, we could not communicate. We must consider many different aspects when choosing the right interface. If we choose too weak of an interface, we might not be able to capture data during our penetration testing efforts. In this section, we will explore all of the things we should consider when purchasing an interface for wi-fi penetration testing.

---

#### How to Choose the Right Interface for the Job

One of the first things that we should consider is capabilities. If our interface is capable of 2.4G and not 5G, we might run into issues when attempting to scan higher band networks. This, of course, is an obvious one, but we should look for the following in our interface:

1. `IEEE 802.11ac or IEEE 802.11ax support`
2. `Supports at least monitor mode and packet injection`

Not all interfaces are equal when it comes to wi-fi penetration testing. We might find that a solo 2.4G card performs better than a more "capable," dual-band card. After all, it comes down to driver support. Not all operating systems have complete support for each card, so we should do our research ahead of time into our chosen chipset.

The chipset of a Wi-Fi card and its driver are crucial factors in penetration testing, as it is important to select a chipset that supports both monitor mode and packet injection. [Airgeddon](https://github.com/v1s1t0r1sh3r3/airgeddon/wiki/Cards%20and%20Chipsets) offers a comprehensive list of Wi-Fi adapters based on their performance. It is important to note that for external Wi-Fi adapters, drivers must be installed manually, whereas built-in adapters in laptops typically do not require manual installation. The installation process for drivers varies depending on the adapter, with different steps required for each model.

---

#### Interface Strength

Much of wi-fi penetration testing comes down to our physical positioning. As such, if a card is too weak, we might find that our efforts will be inadequate. We should always ensure that our card is strong enough to operate at larger and longer ranges. With this, we might want to shoot for longer range cards. One of the ways that we can check on this is through the iwconfig utility.

```sh
Miituberss@htb[/htb]$ iwconfig

wlan0     IEEE 802.11  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
          Retry short  long limit:2   RTS thr:off   Fragment thr:off
          Power Management:off
```
By default, this is set to the country specified in our operating system. We can check on this with the iw reg get command in Linux.

```
Miituberss@htb[/htb]$ iw reg get

global
country 00: DFS-UNSET
        (2402 - 2472 @ 40), (6, 20), (N/A)
        (2457 - 2482 @ 20), (6, 20), (N/A), AUTO-BW, PASSIVE-SCAN
        (2474 - 2494 @ 20), (6, 20), (N/A), NO-OFDM, PASSIVE-SCAN
        (5170 - 5250 @ 80), (6, 20), (N/A), AUTO-BW, PASSIVE-SCAN
        (5250 - 5330 @ 80), (6, 20), (0 ms), DFS, AUTO-BW, PASSIVE-SCAN
        (5490 - 5730 @ 160), (6, 20), (0 ms), DFS, PASSIVE-SCAN
        (5735 - 5835 @ 80), (6, 20), (N/A), PASSIVE-SCAN
        (57240 - 63720 @ 2160), (N/A, 0), (N/A)

```
With this, we can see all of the different txpower settings that we can do for our region. Most of the time, this might be DFS-UNSET, which is not helpful for us since it limits our cards to `20 dBm`. We can change this of course to our own region, but we should abide by pertinent rules and laws when doing this, as it is against the law in different areas to push our card beyond the maximum set limit, and as well it is not always particularly healthy for our interface.

---

#### Changing the Region Settings for our Interface

Suppose we lived in the United States, we might want to change our interfaces region accordingly. We could do so with the iw reg set command, and simply change the US to our region's two letter code.

```sh 
Miituberss@htb[/htb]$ sudo iw reg set US
```

Then, we could check this setting again with the iw reg get command.

```sh
Miituberss@htb[/htb]$ iw reg get

global
country US: DFS-FCC
        (902 - 904 @ 2), (N/A, 30), (N/A)
        (904 - 920 @ 16), (N/A, 30), (N/A)
        (920 - 928 @ 8), (N/A, 30), (N/A)
        (2400 - 2472 @ 40), (N/A, 30), (N/A)
        (5150 - 5250 @ 80), (N/A, 23), (N/A), AUTO-BW
        (5250 - 5350 @ 80), (N/A, 24), (0 ms), DFS, AUTO-BW
        (5470 - 5730 @ 160), (N/A, 24), (0 ms), DFS
        (5730 - 5850 @ 80), (N/A, 30), (N/A), AUTO-BW
        (5850 - 5895 @ 40), (N/A, 27), (N/A), NO-OUTDOOR, AUTO-BW, PASSIVE-SCAN
        (5925 - 7125 @ 320), (N/A, 12), (N/A), NO-OUTDOOR, PASSIVE-SCAN
        (57240 - 71000 @ 2160), (N/A, 40), (N/A)

```

Afterwards, we can check the txpower of our interface with the `iwconfig` utility.

```sh
Miituberss@htb[/htb]$ iwconfig

wlan0     IEEE 802.11  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
          Retry short  long limit:2   RTS thr:off   Fragment thr:off
          Power Management:off

```

In many cases, our interface will automatically set its power to the maximum in our region. However, sometimes we might need to do this ourselves. First, we would have to bring our interface down.

```sh
Miituberss@htb[/htb]$ sudo ifconfig wlan0 down
```
Then, we can set the desired txpower for our interface with the `iwconfig` utility.

```sh
Miituberss@htb[/htb]$ sudo iwconfig wlan0 txpower 30
```

After that, we would need to bring our interface back up.

```sh
Miituberss@htb[/htb]$ sudo ifconfig wlan0 up
```

Next, we can check the settings again by using the `iwconfig` utility.

```sh
Miituberss@htb[/htb]$ iwconfig

wlan0     IEEE 802.11  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=30 dBm   
          Retry short  long limit:2   RTS thr:off   Fragment thr:off
          Power Management:off
```

The default TX power of a wireless interface is typically set to 20 dBm, but it can be increased to 30 dBm using certain methods. However, caution should be exercised, as this adjustment may be illegal in some countries, and users should proceed at their own risk. Additionally, some wireless models may not support these settings, or the wireless chip might technically be capable of transmitting at higher power, but the device manufacturer may not have equipped the device with the necessary heat sink to safely handle the increased output.

The TX power of the wireless interface can be modified using the previously mentioned command. However, in certain instances, this change may not take effect, which could indicate that the kernel has been patched to prevent such modifications.

---

#### Checking Driver Capabilities for our Interface

As mentioned, one of the most important things for our interface, is its capabilities to perform different actions during wi-fi penetration testing. If our interface does not support something, in most cases we simply will not be able to perform that action, unless we acquire another interface. Luckily, we can check on these capabilities via the command line.

The command that we can use to find out this information is the iw list command.

```sh
Miituberss@htb[/htb]$ iw list

Wiphy phy5
    wiphy index: 5
    max # scan SSIDs: 4
    max scan IEs length: 2186 bytes
    max # sched scan SSIDs: 0
    max # match sets: 0
    max # scan plans: 1
    max scan plan interval: -1
    max scan plan iterations: 0
    Retry short limit: 7
    Retry long limit: 4
    Coverage class: 0 (up to 0m)
    Device supports RSN-IBSS.
    Device supports AP-side u-APSD.
    Device supports T-DLS.
    Supported Ciphers:
            * WEP40 (00-0f-ac:1)
            * WEP104 (00-0f-ac:5)
            <SNIP>
            * GMAC-256 (00-0f-ac:12)
    Available Antennas: TX 0 RX 0
    Supported interface modes:
             * IBSS
             * managed
             * AP
             * AP/VLAN
             * monitor
             * mesh point
             * P2P-client
             * P2P-GO
             * P2P-device
    Band 1:
        <SNIP>
        Frequencies:
                * 2412 MHz [1] (20.0 dBm)
                * 2417 MHz [2] (20.0 dBm)
                <SNIP>
                * 2472 MHz [13] (disabled)
                * 2484 MHz [14] (disabled)
    Band 2:
        <SNIP>
        Frequencies:
                * 5180 MHz [36] (20.0 dBm)
                <SNIP>
                * 5260 MHz [52] (20.0 dBm) (radar detection)
                <SNIP>
                * 5700 MHz [140] (20.0 dBm) (radar detection)
                <SNIP>
                * 5825 MHz [165] (20.0 dBm)
                * 5845 MHz [169] (disabled)
    <SNIP>
        Device supports TX status socket option.
        Device supports HT-IBSS.
        Device supports SAE with AUTHENTICATE command
        Device supports low priority scan.
    <SNIP>

```

Of course, this output can be lengthy, but all the information in here is pertinent to our testing efforts. From the above example, we know that this interface supports the following.

1. `Almost all pertinent regular ciphers`
2. `Both 2.4Ghz and 5Ghz bands`
3. `Mesh networks and IBSS capabilities`
4. `P2P peering`
5. `SAE aka WPA3 authentication`

As such, it can be very important for us to check on our interface's capabilities. Suppose we were testing a WPA3 network, and we came to find out that our interface's driver did not support WPA3, we might be left scratching our head.

---

#### Scanning Available WiFi Networks

To efficiently scan for available WiFi networks, we can use the `iwlist` command along with the specific interface name. Given the potentially extensive output of this command, it is beneficial to filter the results to show only the most relevant information. This can be achieved by piping the output through grep to include only lines containing `Cell`, `Quality`, `ESSID`, or `IEEE`.

```sh
Miituberss@htb[/htb]$ iwlist wlan0 scan |  grep 'Cell\|Quality\|ESSID\|IEEE'

          Cell 01 - Address: f0:28:c8:d9:9c:6e
                    Quality=61/70  Signal level=-49 dBm  
                    ESSID:"HTB-Wireless"
                    IE: IEEE 802.11i/WPA2 Version 1
          Cell 02 - Address: 3a:c4:6e:40:09:76
                    Quality=70/70  Signal level=-30 dBm  
                    ESSID:"CyberCorp"
                    IE: IEEE 802.11i/WPA2 Version 1
          Cell 03 - Address: 48:32:c7:a0:aa:6d
                    Quality=70/70  Signal level=-30 dBm  
                    ESSID:"HackTheBox"
                    IE: IEEE 802.11i/WPA2 Version 1

From the refined output of the iwlist command, we can identify that there are three available WiFi networks. This filtered information focuses on the critical details such as the network cells, signal quality, ESSID, and IEEE specifications, making it straightforward to analyze the available networks.

Changing Channel & Frequency of Interface
We can use the following command to see all available channels for the wireless interface:

        shellsession
Miituberss@htb[/htb]$ iwlist wlan0 channel

wlan0     32 channels in total; available frequencies :
          Channel 01 : 2.412 GHz
          Channel 02 : 2.417 GHz
          Channel 03 : 2.422 GHz
          Channel 04 : 2.427 GHz
          <SNIP>
          Channel 140 : 5.7 GHz
          Channel 149 : 5.745 GHz
          Channel 153 : 5.765 GHz

```

From the refined output of the `iwlist` command, we can identify that there are three available WiFi networks. This filtered information focuses on the critical details such as the network cells, signal quality, ESSID, and IEEE specifications, making it straightforward to analyze the available networks.

---

#### Changing Channel & Frequency of Interface

We can use the following command to see all available channels for the wireless interface:

```sh
Miituberss@htb[/htb]$ iwlist wlan0 channel

wlan0     32 channels in total; available frequencies :
          Channel 01 : 2.412 GHz
          Channel 02 : 2.417 GHz
          Channel 03 : 2.422 GHz
          Channel 04 : 2.427 GHz
          <SNIP>
          Channel 140 : 5.7 GHz
          Channel 149 : 5.745 GHz
          Channel 153 : 5.765 GHz
```

First, we need to disable the wireless interface which ensures that the interface is not in use and can be safely reconfigured. Then we can set the desired `channel` using the `iwconfig` command and finally, re-enable the wireless interface.

```sh
Miituberss@htb[/htb]$ sudo ifconfig wlan0 down
Miituberss@htb[/htb]$ sudo iwconfig wlan0 channel 64
Miituberss@htb[/htb]$ sudo ifconfig wlan0 up
Miituberss@htb[/htb]$ iwlist wlan0 channel

wlan0     32 channels in total; available frequencies :
          Channel 01 : 2.412 GHz
          Channel 02 : 2.417 GHz
          Channel 03 : 2.422 GHz
          Channel 04 : 2.427 GHz
          <SNIP>
          Channel 140 : 5.7 GHz
          Channel 149 : 5.745 GHz
          Channel 153 : 5.765 GHz
          Current Frequency:5.32 GHz (Channel 64)
```

As demonstrated in the above output, `Channel 64` operates at a frequency of `5.32 GHz`. By following these steps, we can effectively change the channel of the wireless interface to optimize performance and reduce interference.

If we prefer to change the frequency directly rather than adjusting the channel, we have the option to do so as well.

```sh
Miituberss@htb[/htb]$ iwlist wlan0 frequency | grep Current

          Current Frequency:5.32 GHz (Channel 64)
```

To change the frequency, we first need to disable the wireless interface, which ensures that the interface is not in use and can be safely reconfigured. Then, we can set the desired frequency using the iwconfig command and finally, re-enable the wireless interface.

```sh
Miituberss@htb[/htb]$ sudo ifconfig wlan0 down
Miituberss@htb[/htb]$ sudo iwconfig wlan0 freq "5.52G"
Miituberss@htb[/htb]$ sudo ifconfig wlan0 up
```

We can now verify the current frequency, and this time, we can see that the frequency has been successfully changed to `5.52 GHz`. This change automatically adjusted the channel to the appropriate `channel 104`.

```sh
Miituberss@htb[/htb]$ iwlist wlan0 frequency | grep Current

          Current Frequency:5.52 GHz (Channel 104)
```

---

## Moving On

In this section, we explored how to choose the right interface, change the region settings for our interface, set interface strength, check the drivers, and scan for available WiFi networks. With these foundational steps covered, we are now prepared to delve into the next topic.

In the next section, we will delve into the different modes of a wireless interface. We will examine how each mode operates and its specific applications. Understanding these modes will help us utilize wireless interfaces more effectively for diverse purposes, whether it be for routine connectivity, network troubleshooting, or specialized tasks.
# Interface Modes

---

There are many more pertinent modes we need to know for our wireless interfaces when we conduct wi-fi penetration testing. After all, each mode is responsible for different capabilities and roles when it comes down to the hierarchy of wi-fi communications. In this section, we will explore each of these separate modes, what they do, and how we can test our interface for their capabilities.

---

#### Managed Mode

Managed mode is when we want our interface to act as a client or a station. In other words, this mode allows us to authenticate and associate to an access point, basic service set, and others. In this mode, our card will actively search for nearby networks (APs) to which we can establish a connection.

Pretty much in most cases, our interface will default to this mode, but suppose we want to set our interface to this mode. This could be helpful after setting our interface into monitor mode. We would run the following command.

        shellsession
`Miituberss@htb[/htb]$ sudo ifconfig wlan0 down Miituberss@htb[/htb]$ sudo iwconfig wlan0 mode managed`

Then, to connect to a network, we could utilize the following command.

        shellsession
`Miituberss@htb[/htb]$ sudo iwconfig wlan0 essid HTB-Wifi`

Then, to check our interface, we can utilize the `iwconfig` utility.

        shellsession
`Miituberss@htb[/htb]$ sudo iwconfig wlan0     IEEE 802.11  ESSID:"HTB-Wifi"             Mode:Managed  Access Point: Not-Associated   Tx-Power=30 dBm          Retry short  long limit:2   RTS thr:off   Fragment thr:off          Power Management:off`

---

#### Ad-hoc Mode

Secondarily, we could act in a decentralized approach. This is where ad-hoc mode comes into play. Essentially this mode is peer to peer and allows wireless interfaces to communicate directly to one another. This mode is commonly found in most residential mesh systems for their backhaul bands. That is their band that is utilized for AP-to-AP communications and range extension. However, it is important to note, that this mode is not extender mode, as in most cases that is actually two interfaces bridged together.

To set our interface into this mode, we would run the following commands.

        shellsession
`Miituberss@htb[/htb]$ sudo iwconfig wlan0 mode ad-hoc Miituberss@htb[/htb]$ sudo iwconfig wlan0 essid HTB-Mesh`

Then, once again, we could check our interface with the `iwconfig` command.

        shellsession
`Miituberss@htb[/htb]$ sudo iwconfig wlan0     IEEE 802.11  ESSID:"HTB-Mesh"             Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: Not-Associated          Tx-Power=30 dBm          Retry short  long limit:2   RTS thr:off   Fragment thr:off          Power Management:off`

---

#### Master Mode

On the flip side of managed mode is master mode (access point/router mode). However, we cannot simply set this with the `iwconfig` utility. Rather, we need what is referred to as a management daemon. This management daemon is responsible for responding to stations or clients connecting to our network. Commonly, in wi-fi penetration testing, we would utilize hostapd for this task. As such, we would first want to create a sample configuration.

        shellsession
`Miituberss@htb[/htb]$ nano open.conf interface=wlan0 driver=nl80211 ssid=HTB-Hello-World channel=2 hw_mode=g`

This configuration would simply bring up an open network with the name HTB-Hello-World. With this network configuration, we could bring it up with the following command.

        shellsession
`Miituberss@htb[/htb]$ sudo hostapd open.conf wlan0: interface state UNINITIALIZED->ENABLED wlan0: AP-ENABLED  wlan0: STA 2c:6d:c1:af:eb:91 IEEE 802.11: authenticated wlan0: STA 2c:6d:c1:af:eb:91 IEEE 802.11: associated (aid 1) wlan0: AP-STA-CONNECTED 2c:6d:c1:af:eb:91 wlan0: STA 2c:6d:c1:af:eb:91 RADIUS: starting accounting session D249D3336F052567`

In the above example, hostapd brings our AP up, then we connect another device to our network, and we should notice the connection messages. This would indicate the successful operation of the master mode.

---

#### Mesh Mode

Mesh mode is an interesting one in which we can set our interface to join a self-configuring and routing network. This mode is commonly used for business applications where there is a need for large coverage across a physical space. This mode turns our interface into a mesh point. We can provide additional configuration to make it functional, but generally speaking, we can see if it is possible by whether or not we are greeted with errors after running the following commands.

        shellsession
`Miituberss@htb[/htb]$ sudo iw dev wlan0 set type mesh`

Then we can check our interface once again with the `iwconfig` utility.

        shellsession
`Miituberss@htb[/htb]$ sudo iwconfig wlan0     IEEE 802.11  Mode:Auto  Tx-Power=30 dBm              Retry short  long limit:2   RTS thr:off   Fragment thr:off          Power Management:off`

---

#### Monitor Mode

Monitor mode, also known as promiscuous mode, is a specialized operating mode for wireless network interfaces. In this mode, the network interface can capture all wireless traffic within its range, regardless of the intended recipient. Unlike normal operation, where the interface only captures packets addressed to it or broadcasted, monitor mode enables comprehensive network monitoring and analysis.

Enabling monitor mode typically requires administrative privileges and may vary depending on the operating system and wireless chipset used. Once enabled, monitor mode provides a powerful tool for understanding and managing wireless networks.

First we would need to bring our interface down to avoid a device or resource busy error.

        shellsession
`Miituberss@htb[/htb]$ sudo ifconfig wlan0 down`

Then we could set our interface's mode with iw {interface name} set {mode}

        shellsession
`Miituberss@htb[/htb]$ sudo iw wlan0 set monitor control`

Then we can bring our interface back up.

        shellsession
`Miituberss@htb[/htb]$ sudo ifconfig wlan0 up`

Finally, to ensure that our interface is in monitor mode, we can utilize the `iwconfig` utility.

        shellsession
`Miituberss@htb[/htb]$ iwconfig wlan0     IEEE 802.11  Mode:Monitor  Frequency:2.457 GHz  Tx-Power=30 dBm              Retry short  long limit:2   RTS thr:off   Fragment thr:off          Power Management:off`

Overall, it is important to make sure our interface supports whatever mode is pertinent to our testing efforts. If we are attempting to exploit WEP, WPA, WPA2, WPA3, and all enterprise variants, we are likely sufficient with just monitor mode and packet injection capabilities. However, suppose we were trying to achieve different actions we might consider the following capabilities.

1. `Employing a Rogue AP or Evil-Twin Attack:` - We would want our interface to support master mode with a management daemon like hostapd, hostapd-mana, hostapd-wpe, airbase-ng, and others.
2. `Backhaul and Mesh or Mesh-Type system exploitation:` - We would want to make sure our interface supports ad-hoc and mesh modes accordingly. For this kind of exploitation we are normally sufficient with monitor mode and packet injection, but the extra capabilities can allow us to perform node impersonation among others.

In the next section, we will dive into the essentials of Aircrack-ng, a powerful suite of tools designed for wireless network security assessments. We will cover the core functionalities of Aircrack-ng, including how to use it for capturing packets, analyzing network traffic, and cracking WEP and WPA/WPA2 encryption keys. This exploration will provide you with a solid foundation for using Aircrack-ng tools in your own security evaluations and network assessments.
# Introduction to Aircrack-ng

---

[Aircrack-ng](https://github.com/aircrack-ng/aircrack-ng) comprises a comprehensive suite of tools designed for the evaluation of WiFi network security. Prior to initiating any endeavors to analyze or exploit wireless networks, a foundational understanding of the functionalities inherent within these tools is imperative.

Aircrack-ng focuses on different areas of WiFi security:

- `Monitoring`: Packet capture and export of data to text files for further processing by third party tools.
- `Attacking`: Replay attacks, deauthentication, fake access points and others via packet injection.
- `Testing`: Checking WiFi cards and driver capabilities (capture and injection).
- `Cracking`: WEP and WPA PSK (WPA 1 and 2).

All tools within Aircrack-ng operate through command-line interfaces, facilitating extensive scripting capabilities. This attribute has been leveraged by numerous graphical user interfaces (GUIs). Aircrack-ng predominantly functions on Linux platforms but extends compatibility to Windows, macOS, FreeBSD, OpenBSD, NetBSD, Solaris, and even eComStation 2.

The Aircrack-ng suite encompasses over 20 tools tailored for auditing Wi-Fi networks. We'll concentrate on the six most frequently utilized and essential tools within the suite. These tools are indispensable for various Wi-Fi security auditing tasks and are commonly sought after by users seeking comprehensive network assessment and protection.

|**Tool**|**Description**|
|---|---|
|`Airmon-ng`|Airmon-ng can enable and disable monitor mode on wireless interfaces.|
|`Airodump-ng`|Airodump-ng can capture raw 802.11 frames.|
|`Airgraph-ng`|Airgraph-ng can be used to create graphs of wireless networks using the CSV files generated by Airodump-ng.|
|`Aireplay-ng`|Aireplay-ng can generate wireless traffic.|
|`Airdecap-ng`|Airdecap-ng can decrypt WEP, WPA PSK, or WPA2 PSK capture files.|
|`Aircrack-ng`|Aircrack-ng can crack WEP and WPA/WPA2 networks that use pre-shared keys or PMKID.|

In the upcoming sections, we will go through each of these tools in detail.
# Airmon-ng

---

Monitor mode is a specialized mode for wireless network interfaces, enabling them to capture all traffic within a WiFi range. Unlike managed mode, where an interface only processes frames addressed to it, monitor mode allows the interface to capture every packet of data it detects, regardless of its intended recipient. This capability is invaluable for network analysis, troubleshooting, and security assessments, as it provides a comprehensive view of the network's activity. By enabling monitor mode, users can intercept and analyze packets, detect unauthorized devices, identify network vulnerabilities, and gather comprehensive data on wireless networks. This mode provides a deeper level of insight into the wireless environment, facilitating more effective troubleshooting, security assessments, and performance evaluations.

---

### Starting monitor mode

Airmon-ng can be used to enable monitor mode on wireless interfaces. It may also be used to kill network managers, or go back from monitor mode to managed mode. Entering the `airmon-ng` command without parameters will show the wireless interface name, driver and chipset.

        shellsession
`Miituberss@htb[/htb]$ sudo airmon-ng PHY     Interface       Driver          Chipset phy0    wlan0           rt2800usb       Ralink Technology, Corp. RT2870/RT3070`

We can set the wlan0 interface into monitor mode using the command `airmon-ng start wlan0`.

        shellsession
`Miituberss@htb[/htb]$ sudo airmon-ng start wlan0 Found 2 processes that could cause trouble. Kill them using 'airmon-ng check kill' before putting the card in monitor mode, they will interfere by changing channels and sometimes putting the interface back in managed mode     PID Name    559 NetworkManager    798 wpa_supplicant PHY     Interface       Driver          Chipset phy0    wlan0           rt2800usb       Ralink Technology, Corp. RT2870/RT3070                 (mac80211 monitor mode vif enabled for [phy0]wlan0 on [phy0]wlan0mon)                (mac80211 station mode vif disabled for [phy0]wlan0)`

We could test to see if our interface is in monitor mode with the iwconfig utility.

        shellsession
`Miituberss@htb[/htb]$ iwconfig wlan0mon  IEEE 802.11  Mode:Monitor  Frequency:2.457 GHz  Tx-Power=30 dBm              Retry short  long limit:2   RTS thr:off   Fragment thr:off          Power Management:off`

From the above output, it can be observed that the interface has been successfully set to monitor mode. The new name of the interface is now wlan0mon instead of wlan0, indicating that it is operating in monitor mode.

---

### Checking for interfering processes

When putting a card into monitor mode, it will automatically check for interfering processes. It can also be done manually by running the following command:

        shellsession
`Miituberss@htb[/htb]$ sudo airmon-ng check Found 5 processes that could cause trouble. If airodump-ng, aireplay-ng or airtun-ng stops working after a short period of time, you may want to kill (some of) them!   PID Name  718 NetworkManager  870 dhclient 1104 avahi-daemon 1105 avahi-daemon 1115 wpa_supplicant`

As shown in the above output, there are 5 interfering processes that can cause issues by changing channels or putting the interface back into managed mode. If we encounter problems during our engagement, we can terminate these processes using the airmon-ng check kill command.

However, it is important to note that this step should only be taken if we are experiencing challenges during the pentesting process.

        shellsession
`Miituberss@htb[/htb]$ sudo airmon-ng check kill Killing these processes:   PID Name  870 dhclient 1115 wpa_supplicant`

---

### Starting monitor mode on a specific channel

It is also possible to set the wireless card to a specific channel using `airmon-ng`. We can specify the desired channel while enabling monitor mode on the wlan0 interface.

        shellsession
`Miituberss@htb[/htb]$ sudo airmon-ng start wlan0 11 Found 5 processes that could cause trouble. If airodump-ng, aireplay-ng or airtun-ng stops working after a short period of time, you may want to kill (some of) them!   PID Name  718 NetworkManager  870 dhclient 1104 avahi-daemon 1105 avahi-daemon 1115 wpa_supplicant PHY     Interface       Driver          Chipset phy0    wlan0           rt2800usb       Ralink Technology, Corp. RT2870/RT3070                 (mac80211 monitor mode vif enabled for [phy0]wlan0 on [phy0]wlan0mon)                (mac80211 station mode vif disabled for [phy0]wlan0)`

The above command will set the card into monitor mode on channel 11. This ensures that the `wlan0` interface operates specifically on channel 11 while in monitor mode.

### Stopping monitor mode

We can stop the monitor mode on the `wlan0mon` interface using the command `airmon-ng stop wlan0mon`.

        shellsession
`Miituberss@htb[/htb]$ sudo airmon-ng stop wlan0mon PHY     Interface       Driver          Chipset phy0    wlan0mon        rt2800usb       Ralink Technology, Corp. RT2870/RT3070                 (mac80211 station mode vif enabled on [phy0]wlan0)                (mac80211 monitor mode vif disabled for [phy0]wlan0)`

We could test to see if our interface is back to managed mode with the iwconfig utility.

        shellsession
`Miituberss@htb[/htb]$ iwconfig wlan0  IEEE 802.11  Mode:Managed  Frequency:2.457 GHz  Tx-Power=30 dBm              Retry short  long limit:2   RTS thr:off   Fragment thr:off          Power Management:off`

---

## Moving On

In the next section, we will examine the tool airodump-ng. Airodump-ng is used for packet capture, specifically capturing raw 802.11 frames. It generates several files containing detailed information about all detected access points and clients, allowing us to scan for available WiFi networks effectively.
# Airodump-ng

---

Airodump-ng serves as a tool for capturing packets, specifically targeting raw 802.11 frames. Its primary function lies in the collection of WEP IVs (Initialization Vectors) or WPA/WPA2 handshakes, which are subsequently utilized with aircrack-ng for security assessment purposes.

Furthermore, airodump-ng generates multiple files containing comprehensive information regarding all identified access points and clients. These files can be harnessed for scripting purposes or the development of personalized tools.

`airodump-ng` provides a wealth of information when scanning for WiFi networks. The table below explains each field along with its description:

|**Field**|**Description**|
|---|---|
|`BSSID`|Shows the MAC address of the access points|
|`PWR`|Shows the "power" of the network. The higher the number, the better the signal strength.|
|`Beacons`|Shows the number of announcement packets sent by the network.|
|`#Data`|Shows the number of captured data packets.|
|`#/s`|Shows the number of data packets captured in the past ten seconds.|
|`CH`|Shows the "Channel" the network runs on.|
|`MB`|Shows the maximum speed supported by the network.|
|`ENC`|Shows the encryption method used by the network.|
|`CIPHER`|Shows the cipher used by the network.|
|`AUTH`|Shows the authentication used by the network.|
|`ESSID`|Shows the name of the network.|
|`STATION`|Shows the MAC address of the client connected to the network.|
|`RATE`|Shows the data transfer rate between the client and the access point.|
|`LOST`|Shows the number of data packets lost.|
|`Packets`|Shows the number of data packets sent by the client.|
|`Notes`|Shows additional information about the client, such as captured EAPOL or PMKID.|
|`PROBES`|Shows the list of networks the client is probing for.|

To utilize airodump-ng effectively, the first step is to activate `monitor mode` on the wireless interface. This mode allows the interface to capture all the wireless traffic in its vicinity. We can use `airmon-ng` to enable monitor mode on the interface, as shown in the previous section.

        shellsession
`Miituberss@htb[/htb]$ sudo airmon-ng start wlan0 Found 2 processes that could cause trouble. Kill them using 'airmon-ng check kill' before putting the card in monitor mode, they will interfere by changing channels and sometimes putting the interface back in managed mode     PID Name    559 NetworkManager    798 wpa_supplicant PHY     Interface       Driver          Chipset phy0    wlan0           rt2800usb       Ralink Technology, Corp. RT2870/RT3070                 (mac80211 monitor mode vif enabled for [phy0]wlan0 on [phy0]wlan0mon)                (mac80211 station mode vif disabled for [phy0]wlan0)`

        shellsession
`Miituberss@htb[/htb]$ iwconfig eth0      no wireless extensions. wlan0mon  IEEE 802.11  Mode:Monitor  Frequency:2.457 GHz  Tx-Power=20 dBm              Retry short limit:7   RTS thr:off   Fragment thr:off          Power Management:on           lo        no wireless extensions.`

Once Monitor mode is enabled, we can run `airodump-ng` by specifying the name of the targeted wireless interface, such as `airodump-ng wlan0mon`. This command prompts airodump-ng to start scanning and collecting data on the wireless access points detectable by the specified interface.

The output generated by `airodump-ng wlan0mon` will present a structured table containing detailed information about the identified wireless access points.

        shellsession
`Miituberss@htb[/htb]$ sudo airodump-ng wlan0mon CH  9 ][ Elapsed: 1 min ][ 2007-04-26 17:41 ][                                                                                                               BSSID              PWR RXQ  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID                                                                                                              00:09:5B:1C:AA:1D   11  16       10        0    0  11  54.  OPN              NETGEAR 00:14:6C:7A:41:81   34 100       57       14    1  48  11e  WEP  WEP         bigbear 00:14:6C:7E:40:80   32 100      752       73    2   9  54   WPA  TKIP   PSK  teddy                                                                                                              BSSID              STATION            PWR   Rate   Lost  Frames   Notes  Probes                                  00:14:6C:7A:41:81  00:0F:B5:32:31:31   51   36-24    2       14           bigbear (not associated)   00:14:A4:3F:8D:13   19    0-0     0        4           mossy 00:14:6C:7A:41:81  00:0C:41:52:D1:D1   -1   36-36    0        5           bigbear 00:14:6C:7E:40:80  00:0F:B5:FD:FB:C2   35   54-54    0       99           teddy`

From the above output, we can see that there are three available WiFi networks or access points (APs): `NETGEAR`, `bigbear`, and `teddy`. NETGEAR has the BSSID `00:09:5B:1C:AA:1D` and uses OPN (open) encryption. Bigbear has the BSSID `00:14:6C:7A:41:81` and uses WEP encryption. Teddy has the BSSID `00:14:6C:7E:40:80` and uses WPA encryption.

The stations shown below represent the clients connected to the WiFi network. By checking the station ID along with the BSSID, we can determine which client is connected to which WiFi network. For example, the client with station ID `00:0F:B5:FD:FB:C2` is connected to the `teddy` network.

---

### Scanning Specific Channels or a Single Channel

The command `airodump-ng wlan0mon` initiates a comprehensive scan, collecting data on wireless access points across all the `channels` available. However, we can specify a particular channel using the `-c` option to focus the scan on a specific frequency. For instance, `-c 11` would narrow the scan to `channel 11`. This targeted approach can provide more refined results, especially in crowded Wi-Fi environments.

Example of a single channel:

        shellsession
`Miituberss@htb[/htb]$ sudo airodump-ng -c 11 wlan0mon CH  11 ][ Elapsed: 1 min ][ 2024-05-18 17:41 ][                                                                                                               BSSID              PWR RXQ  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID                                                                                                              00:09:5B:1C:AA:1D   11  16       10        0    0  11  54.  OPN              NETGEAR                           BSSID              STATION            PWR   Rate   Lost  Frames  Notes  Probes                                  (not associated)   00:0F:B5:32:31:31  -29    0      42        4 (not associated)   00:14:A4:3F:8D:13  -29    0       0        4 (not associated)   00:0C:41:52:D1:D1  -29    0       0        5 (not associated)   00:0F:B5:FD:FB:C2  -29    0       0       22`

It is also possible to select multiple channels for scanning using the command `airodump-ng -c 1,6,11 wlan0mon`.

---

### Scanning 5 GHz Wi-Fi bands

By default, airodump-ng is configured to scan exclusively for networks operating on the 2.4 GHz band. Nevertheless, if the wireless adapter is compatible with the 5 GHz band, we can instruct airodump-ng to include this frequency range in its scan by utilizing the `--band` option. You can find a list of all WLAN channels and bands available for Wi-Fi [here](https://en.wikipedia.org/wiki/List_of_WLAN_channels).

The supported bands are a, b, and g.

- `a` uses 5 GHz
- `b` uses 2.4 GHz
- `g` uses 2.4 GHz

        shellsession
`Miituberss@htb[/htb]$ sudo airodump-ng wlan0mon --band a CH  48 ][ Elapsed: 1 min ][ 2024-05-18 17:41 ][                                                                                                                BSSID              PWR RXQ  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID                                                                                                              00:14:6C:7A:41:81   34 100       57       14    1  48  11e  WPA  TKIP        HTB                          BSSID              STATION            PWR   Rate   Lost  Frames  Notes  Probes                                   (not associated)   00:0F:B5:32:31:31  -29    0      42        4 (not associated)   00:14:A4:3F:8D:13  -29    0       0        4 (not associated)   00:0C:41:52:D1:D1  -29    0       0        5 (not associated)   00:0F:B5:FD:FB:C2  -29    0       0       22`

When employing the `--band` option, we have the flexibility to specify either a single band or a combination of bands according to our scanning needs. For instance, to scan across all available bands, we can execute the command `airodump-ng --band abg wlan0mon`. This command instructs airodump-ng to scan for networks across the `a`, `b`, and `g` bands simultaneously, providing a comprehensive overview of the wireless landscape accessible to the specified wireless interface, wlan0mon.

---

### Saving the output to a file

We can preserve the outcomes of our `airodump-ng` scan by utilizing the `--write <prefix>` parameter. This action generates multiple files with the specified prefix filename. For instance, executing `airodump-ng wlan0mon --write HTB` will generate the following files in the current directory.

- HTB-01.cap
- HTB-01.csv
- HTB-01.kismet.csv
- HTB-01.kismet.netxml
- HTB-01.log.csv

        shellsession
`Miituberss@htb[/htb]$ sudo airodump-ng wlan0mon -w HTB 11:32:13  Created capture file "HTB-01.cap". CH  9 ][ Elapsed: 1 min ][ 2007-04-26 17:41 ][                                                                                                               BSSID              PWR RXQ  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID                                                                                                              00:09:5B:1C:AA:1D   11  16       10        0    0  11  54.  OPN              NETGEAR 00:14:6C:7A:41:81   34 100       57       14    1  48  11e  WEP  WEP         bigbear 00:14:6C:7E:40:80   32 100      752       73    2   9  54   WPA  TKIP   PSK  teddy                                                                                                              BSSID              STATION            PWR   Rate   Lost  Frames   Notes  Probes                                  00:14:6C:7A:41:81  00:0F:B5:32:31:31   51   36-24    2       14           bigbear (not associated)   00:14:A4:3F:8D:13   19    0-0     0        4           mossy 00:14:6C:7A:41:81  00:0C:41:52:D1:D1   -1   36-36    0        5           bigbear 00:14:6C:7E:40:80  00:0F:B5:FD:FB:C2   35   54-54    0       99           teddy`

Every time airodump-ng is executed with the command to capture either IVs (Initialization Vectors) or complete packets, it generates additional text files that are saved onto the disk. These files share the same name with the original output and are differentiated by suffixes: ".csv" for CSV files, ".kismet.csv" for Kismet CSV files, and ".kismet.netxml" for Kismet newcore netxml files. These generated files serve different purposes, facilitating diverse forms of data analysis and compatibility with various network analysis tools.

        shellsession
`Miituberss@htb[/htb]$ ls HTB-01.csv   HTB-01.kismet.netxml   HTB-01.cap   HTB-01.kismet.csv   HTB-01.log.csv`

---

## Moving On

In the next section, we'll explore how to interpret these files visually, allowing us to observe the available Access Points (APs) and clients in a graphical representation. This visual analysis enhances our understanding of the network environment by presenting data in a more intuitive format.
