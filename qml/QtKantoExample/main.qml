import QtQuick 1.0
import QtWebKit 1.0

Rectangle {
	width: 600
	height: 400

        // 動画一覧
        ListView {
                id: videolist

                model: ytlist
                delegate: Column{
                        Image {
                                source: thumbnail

                                MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                                videoplayer.url = "http://www.youtube.com/embed/" + videoId // + "?html5=1"
                                        }
                                }
                        }

                        Text {text: title}
                }

                anchors.top: in_keyword.bottom
                anchors.margins: 10
                width: parent.width / 3
                height: parent.height
        }

        // Player
        WebView {
                id: videoplayer

                url: ""
                settings.pluginsEnabled: true

                anchors.top: in_keyword.bottom
                anchors.left: videolist.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
        }

	// ラベル
	Text {
		id: text1
		x: 14
		y: 15
		text: "検索キーワード:"
		font.pixelSize: 12
	}

	// 検索キーワードを入力するテキストボックス
	TextInput {
		id: in_keyword

		anchors.left: text1.right // テキストボックスの左をラベルの右側と揃える
		anchors.verticalCenter: text1.verticalCenter // テキストボックスの横方向の中心線をラベルの中心線とあわせる
		anchors.margins: 10 // コンポーネント同士のマージン (間隔) を10に設定

		width: 137
		height: 20
		text: "キーワードをここに入力"
		font.pixelSize: 12
	}

	// 検索ボタン
	Rectangle {
		id: button
		anchors.left: in_keyword.right
		anchors.verticalCenter: in_keyword.verticalCenter
		anchors.margins: 10

		width: 72
		height: 20
		color: "#ffffff"

		Text {
			id: buttontext
			anchors.centerIn: parent
			text: "検索"
			font.pixelSize: 12
		}

		// マウスに対するイベント
		MouseArea {
			anchors.fill: parent
			onClicked: {
				// クリックされた時に、XmlListModel (ytlist) の解析対象 XML の URL を変更する
				ytlist.source = "http://gdata.youtube.com/feeds/api/videos?v=2&q=" + in_keyword.text
			}
		}
	}

	XmlListModel {
		id: ytlist

		source: ""
		query: "/feed/entry" // XPath で <entry> タグを繰り返し読込

		namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom'; declare namespace media='http://search.yahoo.com/mrss/'; declare namespace yt='http://gdata.youtube.com/schemas/2007';"

		XmlRole { name: "title"; query: "title/string()" }
		XmlRole {
			name: "thumbnail"
			query: "media:group/media:thumbnail[1]/@url/string()"
		}
		XmlRole {
			name: "videoId"
			query: "media:group/yt:videoid/string()"
		}
	}
}
