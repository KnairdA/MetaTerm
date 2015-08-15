#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
	QApplication application(argc, argv);
	application.setOrganizationName("akr");
	application.setApplicationName("MetaTerm");

	QQmlApplicationEngine engine(QUrl(QStringLiteral("qrc:/main.qml")));

	QObject::connect(
		static_cast<QObject*>(&engine),
		SIGNAL(quit()),
		static_cast<QObject*>(&application),
		SLOT(quit())
	);

	return application.exec();
}
