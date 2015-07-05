#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
	QApplication app(argc, argv);
	QQmlApplicationEngine engine;

	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

	QObject::connect(
		static_cast<QObject*>(&engine),
		SIGNAL(quit()),
		static_cast<QObject*>(&app),
		SLOT(quit())
	);

	return app.exec();
}
