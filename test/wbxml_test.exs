defmodule WbxmlTest do
  use ExUnit.Case
  doctest Wbxml

  test "decode wbxml request 120" do
    {:ok, bytes} = File.read("test/wbxml_samples/request-120.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Ping><HeartbeatInterval>120</HeartbeatInterval><Folders><Folder><Id>14</Id><Class>Email</Class></Folder><Folder><Id>4</Id><Class>Calendar</Class></Folder><Folder><Id>5</Id><Class>Calendar</Class></Folder><Folder><Id>6</Id><Class>Calendar</Class></Folder><Folder><Id>7</Id><Class>Contacts</Class></Folder><Folder><Id>8</Id><Class>Contacts</Class></Folder></Folders></Ping>"
  end

  test "decode wbxml response 151" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-151.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Sync><Collections><Collection><SyncKey>1509029063</SyncKey><CollectionId>7</CollectionId><Status>1</Status></Collection></Collections></Sync>"
  end

  test "encode wbxml response 151" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-151.wbxml")

    xml =
      "<Sync xmlns='airsync'><Collections><Collection><SyncKey>1509029063</SyncKey><CollectionId>7</CollectionId><Status>1</Status></Collection></Collections></Sync>"

    encode_bytes = Wbxml.encode(xml)
    assert bytes == encode_bytes
  end

  test "decode wbxml response 277" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-277.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Sync><Collections><Collection><SyncKey>1019810487</SyncKey><CollectionId>1</CollectionId><Status>1</Status></Collection></Collections></Sync>"
  end

  test "decode wbxml response 884" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-884.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Sync><Collections><Collection><SyncKey>28589765</SyncKey><CollectionId>2</CollectionId><Status>1</Status></Collection></Collections></Sync>"
  end

  test "decode wbxml response 1858" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-1858.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<FolderSync><Status>1</Status><SyncKey>1</SyncKey><Changes><Count>32</Count><Add><ServerId>1</ServerId><ParentId>0</ParentId><DisplayName>Calendar</DisplayName><Type>8</Type></Add><Add><ServerId>2</ServerId><ParentId>0</ParentId><DisplayName>Contacts</DisplayName><Type>9</Type></Add><Add><ServerId>32</ServerId><ParentId>2</ParentId><DisplayName>Help</DisplayName><Type>14</Type></Add><Add><ServerId>31</ServerId><ParentId>2</ParentId><DisplayName>Suggested Contacts</DisplayName><Type>14</Type></Add><Add><ServerId>3</ServerId><ParentId>0</ParentId><DisplayName>Deleted Items</DisplayName><Type>4</Type></Add><Add><ServerId>11</ServerId><ParentId>3</ParentId><DisplayName>Another Folder 3</DisplayName><Type>12</Type></Add><Add><ServerId>27</ServerId><ParentId>11</ParentId><DisplayName>Test1</DisplayName><Type>12</Type></Add><Add><ServerId>28</ServerId><ParentId>27</ParentId><DisplayName>Test1sub</DisplayName><Type>12</Type></Add><Add><ServerId>29</ServerId><ParentId>11</ParentId><DisplayName>Test5</DisplayName><Type>12</Type></Add><Add><ServerId>30</ServerId><ParentId>29</ParentId><DisplayName>Test5sub</DisplayName><Type>12</Type></Add><Add><ServerId>26</ServerId><ParentId>3</ParentId><DisplayName>Test4</DisplayName><Type>12</Type></Add><Add><ServerId>4</ServerId><ParentId>0</ParentId><DisplayName>Drafts</DisplayName><Type>3</Type></Add><Add><ServerId>5</ServerId><ParentId>0</ParentId><DisplayName>Hier</DisplayName><Type>12</Type></Add><Add><ServerId>38</ServerId><ParentId>5</ParentId><DisplayName>from ol on osx</DisplayName><Type>1</Type></Add><Add><ServerId>7</ServerId><ParentId>0</ParentId><DisplayName>Inbox</DisplayName><Type>2</Type></Add><Add><ServerId>8</ServerId><ParentId>7</ParentId><DisplayName>Another Folder</DisplayName><Type>12</Type></Add><Add><ServerId>9</ServerId><ParentId>8</ParentId><DisplayName>127852Test</DisplayName><Type>12</Type></Add><Add><ServerId>33</ServerId><ParentId>7</ParentId><DisplayName>Another folder 1</DisplayName><Type>12</Type></Add><Add><ServerId>10</ServerId><ParentId>7</ParentId><DisplayName>Another Folder 2</DisplayName><Type>12</Type></Add><Add><ServerId>24</ServerId><ParentId>10</ParentId><DisplayName>Test2</DisplayName><Type>12</Type></Add><Add><ServerId>25</ServerId><ParentId>10</ParentId><DisplayName>Test3</DisplayName><Type>12</Type></Add><Add><ServerId>34</ServerId><ParentId>7</ParentId><DisplayName>Test Folder</DisplayName><Type>1</Type></Add><Add><ServerId>12</ServerId><ParentId>0</ParentId><DisplayName>Integration Test Emails</DisplayName><Type>12</Type></Add><Add><ServerId>13</ServerId><ParentId>0</ParentId><DisplayName>Journal</DisplayName><Type>11</Type></Add><Add><ServerId>14</ServerId><ParentId>0</ParentId><DisplayName>Junk E-Mail</DisplayName><Type>12</Type></Add><Add><ServerId>15</ServerId><ParentId>0</ParentId><DisplayName>Notes</DisplayName><Type>10</Type></Add><Add><ServerId>16</ServerId><ParentId>0</ParentId><DisplayName>Outbox</DisplayName><Type>6</Type></Add><Add><ServerId>17</ServerId><ParentId>0</ParentId><DisplayName>Sent Items</DisplayName><Type>5</Type></Add><Add><ServerId>35</ServerId><ParentId>0</ParentId><DisplayName>Sg test</DisplayName><Type>12</Type></Add><Add><ServerId>18</ServerId><ParentId>0</ParentId><DisplayName>Tasks</DisplayName><Type>7</Type></Add><Add><ServerId>39</ServerId><ParentId>0</ParentId><DisplayName>testvh</DisplayName><Type>12</Type></Add><Add><ServerId>RI</ServerId><ParentId>0</ParentId><DisplayName>RecipientInfo</DisplayName><Type>19</Type></Add></Changes></FolderSync>"
  end

  test "decode wbxml response 3786" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-3786.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<FolderSync><Status>1</Status><SyncKey>1</SyncKey><Changes><Count>32</Count><Add><ServerId>1</ServerId><ParentId>0</ParentId><DisplayName>Calendar</DisplayName><Type>8</Type></Add><Add><ServerId>2</ServerId><ParentId>0</ParentId><DisplayName>Contacts</DisplayName><Type>9</Type></Add><Add><ServerId>32</ServerId><ParentId>2</ParentId><DisplayName>Help</DisplayName><Type>14</Type></Add><Add><ServerId>31</ServerId><ParentId>2</ParentId><DisplayName>Suggested Contacts</DisplayName><Type>14</Type></Add><Add><ServerId>3</ServerId><ParentId>0</ParentId><DisplayName>Deleted Items</DisplayName><Type>4</Type></Add><Add><ServerId>11</ServerId><ParentId>3</ParentId><DisplayName>Another Folder 3</DisplayName><Type>12</Type></Add><Add><ServerId>27</ServerId><ParentId>11</ParentId><DisplayName>Test1</DisplayName><Type>12</Type></Add><Add><ServerId>28</ServerId><ParentId>27</ParentId><DisplayName>Test1sub</DisplayName><Type>12</Type></Add><Add><ServerId>29</ServerId><ParentId>11</ParentId><DisplayName>Test5</DisplayName><Type>12</Type></Add><Add><ServerId>30</ServerId><ParentId>29</ParentId><DisplayName>Test5sub</DisplayName><Type>12</Type></Add><Add><ServerId>26</ServerId><ParentId>3</ParentId><DisplayName>Test4</DisplayName><Type>12</Type></Add><Add><ServerId>4</ServerId><ParentId>0</ParentId><DisplayName>Drafts</DisplayName><Type>3</Type></Add><Add><ServerId>5</ServerId><ParentId>0</ParentId><DisplayName>Hier</DisplayName><Type>12</Type></Add><Add><ServerId>38</ServerId><ParentId>5</ParentId><DisplayName>from ol on osx</DisplayName><Type>1</Type></Add><Add><ServerId>7</ServerId><ParentId>0</ParentId><DisplayName>Inbox</DisplayName><Type>2</Type></Add><Add><ServerId>8</ServerId><ParentId>7</ParentId><DisplayName>Another Folder</DisplayName><Type>12</Type></Add><Add><ServerId>9</ServerId><ParentId>8</ParentId><DisplayName>127852Test</DisplayName><Type>12</Type></Add><Add><ServerId>33</ServerId><ParentId>7</ParentId><DisplayName>Another folder 1</DisplayName><Type>12</Type></Add><Add><ServerId>10</ServerId><ParentId>7</ParentId><DisplayName>Another Folder 2</DisplayName><Type>12</Type></Add><Add><ServerId>24</ServerId><ParentId>10</ParentId><DisplayName>Test2</DisplayName><Type>12</Type></Add><Add><ServerId>25</ServerId><ParentId>10</ParentId><DisplayName>Test3</DisplayName><Type>12</Type></Add><Add><ServerId>34</ServerId><ParentId>7</ParentId><DisplayName>Test Folder</DisplayName><Type>1</Type></Add><Add><ServerId>12</ServerId><ParentId>0</ParentId><DisplayName>Integration Test Emails</DisplayName><Type>12</Type></Add><Add><ServerId>13</ServerId><ParentId>0</ParentId><DisplayName>Journal</DisplayName><Type>11</Type></Add><Add><ServerId>14</ServerId><ParentId>0</ParentId><DisplayName>Junk E-Mail</DisplayName><Type>12</Type></Add><Add><ServerId>15</ServerId><ParentId>0</ParentId><DisplayName>Notes</DisplayName><Type>10</Type></Add><Add><ServerId>16</ServerId><ParentId>0</ParentId><DisplayName>Outbox</DisplayName><Type>6</Type></Add><Add><ServerId>17</ServerId><ParentId>0</ParentId><DisplayName>Sent Items</DisplayName><Type>5</Type></Add><Add><ServerId>35</ServerId><ParentId>0</ParentId><DisplayName>Sg test</DisplayName><Type>12</Type></Add><Add><ServerId>18</ServerId><ParentId>0</ParentId><DisplayName>Tasks</DisplayName><Type>7</Type></Add><Add><ServerId>39</ServerId><ParentId>0</ParentId><DisplayName>testvh</DisplayName><Type>12</Type></Add><Add><ServerId>RI</ServerId><ParentId>0</ParentId><DisplayName>RecipientInfo</DisplayName><Type>19</Type></Add></Changes></FolderSync>"
  end

  test "decode wbxml response 4148" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-4148.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Provision><Status>1</Status><Policies><Policy><PolicyType>MS-EAS-Provisioning-WBXML</PolicyType><Status>1</Status><PolicyKey>787138854</PolicyKey></Policy></Policies></Provision>"
  end

  test "decode wbxml response 4569" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-4569.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Sync><Collections><Collection><SyncKey>1437611349</SyncKey><CollectionId>RI</CollectionId><Status>1</Status></Collection></Collections></Sync>"
  end

  test "decode wbxml response 6318" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-6318.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Sync><Collections><Collection><SyncKey>1219289161</SyncKey><CollectionId>2</CollectionId><Status>1</Status></Collection></Collections></Sync>"
  end

  test "decode wbxml response 6801" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-6801.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Sync><Collections><Collection><SyncKey>500509522</SyncKey><CollectionId>7</CollectionId><Status>1</Status></Collection></Collections></Sync>"
  end

  test "decode wbxml response 7407" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-7407.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Provision><Status>1</Status><Policies><Policy><PolicyType>MS-EAS-Provisioning-WBXML</PolicyType><Status>1</Status><PolicyKey>787138854</PolicyKey></Policy></Policies></Provision>"
  end

  test "decode wbxml response 8661" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-8661.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<FolderSync><Status>1</Status><SyncKey>1</SyncKey><Changes><Count>0</Count></Changes></FolderSync>"
  end

  test "decode wbxml response 9104" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-9104.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Sync><Collections><Collection><SyncKey>1953161700</SyncKey><CollectionId>RI</CollectionId><Status>1</Status></Collection></Collections></Sync>"
  end

  test "decode wbxml response 9542" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-9542.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<Provision><DeviceInformation><Status>1</Status></DeviceInformation><Status>1</Status><Policies><Policy><PolicyType>MS-EAS-Provisioning-WBXML</PolicyType><Status>1</Status><PolicyKey>1391954320</PolicyKey><Data><EASProvisionDoc><DevicePasswordEnabled>0</DevicePasswordEnabled><AlphanumericDevicePasswordRequired>0</AlphanumericDevicePasswordRequired><PasswordRecoveryEnabled>0</PasswordRecoveryEnabled><RequireStorageCardEncryption>0</RequireStorageCardEncryption><AttachmentsEnabled>1</AttachmentsEnabled><MinDevicePasswordLength/><MaxInactivityTimeDeviceLock/><MaxDevicePasswordFailedAttempts/><MaxAttachmentSize/><AllowSimpleDevicePassword>1</AllowSimpleDevicePassword><DevicePasswordExpiration/><DevicePasswordHistory>0</DevicePasswordHistory><AllowStorageCard>1</AllowStorageCard><AllowCamera>1</AllowCamera><RequireDeviceEncryption>0</RequireDeviceEncryption><AllowUnsignedApplications>1</AllowUnsignedApplications><AllowUnsignedInstallationPackages>1</AllowUnsignedInstallationPackages><MinDevicePasswordComplexCharacters>1</MinDevicePasswordComplexCharacters><AllowWiFi>1</AllowWiFi><AllowTextMessaging>1</AllowTextMessaging><AllowPOPIMAPEmail>1</AllowPOPIMAPEmail><AllowBluetooth>2</AllowBluetooth><AllowIrDA>1</AllowIrDA><RequireManualSyncWhenRoaming>0</RequireManualSyncWhenRoaming><AllowDesktopSync>1</AllowDesktopSync><MaxCalendarAgeFilter>0</MaxCalendarAgeFilter><AllowHTMLEmail>1</AllowHTMLEmail><MaxEmailAgeFilter>0</MaxEmailAgeFilter><MaxEmailBodyTruncationSize>-1</MaxEmailBodyTruncationSize><MaxEmailHTMLBodyTruncationSize>-1</MaxEmailHTMLBodyTruncationSize><RequireSignedSMIMEMessages>0</RequireSignedSMIMEMessages><RequireEncryptedSMIMEMessages>0</RequireEncryptedSMIMEMessages><RequireSignedSMIMEAlgorithm>0</RequireSignedSMIMEAlgorithm><RequireEncryptionSMIMEAlgorithm>0</RequireEncryptionSMIMEAlgorithm><AllowSMIMEEncryptionAlgorithmNegotiation>2</AllowSMIMEEncryptionAlgorithmNegotiation><AllowSMIMESoftCerts>1</AllowSMIMESoftCerts><AllowBrowser>1</AllowBrowser><AllowConsumerEmail>1</AllowConsumerEmail><AllowRemoteDesktop>1</AllowRemoteDesktop><AllowInternetSharing>1</AllowInternetSharing><UnapprovedInROMApplicationList/><ApprovedApplicationList/></EASProvisionDoc></Data></Policy></Policies></Provision>"
  end

  test "decode wbxml response 9777" do
    {:ok, bytes} = File.read("test/wbxml_samples/response-9777.wbxml")
    xml = Wbxml.decode(bytes)

    assert xml ==
             "<FolderSync><Status>1</Status><SyncKey>1</SyncKey><Changes><Count>0</Count></Changes></FolderSync>"
  end

  test "xml file encode 100" do
    {:ok, xml} = File.read("test/xml_samples/res-100.xml")
    {:ok, wbxml_bytes} = File.read("test/xml_samples/res-100-1.wbxml")

    assert Wbxml.encode(xml) == wbxml_bytes
  end

  test "xml file encode 200" do
    {:ok, xml} = File.read("test/xml_samples/res-200.xml")
    {:ok, wbxml_bytes} = File.read("test/xml_samples/res-200-1.wbxml")

    assert Wbxml.encode(xml) == wbxml_bytes
  end

  test "xml file encode 300" do
    {:ok, xml} = File.read("test/xml_samples/res-300.xml")
    {:ok, wbxml_bytes} = File.read("test/xml_samples/res-300-1.wbxml")

    assert Wbxml.encode(xml) == wbxml_bytes
  end

  test "Namespace declaration simple" do
    xml =
      "<Provision xmlns:provision=\"Provision:\"></Provision>"
    Wbxml.encode(xml)
  end

  test "Namespace declaration" do
    xml =
      """
      <airsync:Sync xmlns:airsync="AirSync:" xmlns:calendar="Calendar:" xmlns:email="Email:" xmlns:airsyncbase="AirSyncBase:">
        <airsync:Collections>
          <airsync:Collection>
            <airsync:SyncKey>0</airsync:SyncKey>
            <airsync:CollectionId>1</airsync:CollectionId>
            <airsync:Options>
            <airsync:FilterType>0</airsync:FilterType>
            <airsyncbase:BodyPreference>
            <airsyncbase:Type>1</airsyncbase:Type>
            </airsyncbase:BodyPreference>
            </airsync:Options>
          </airsync:Collection>
        </airsync:Collections>
      </airsync:Sync>
      """
    Wbxml.encode(xml)
  end
end
