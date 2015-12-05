#include <QDir>
#include <QQmlContext>
#include <QApplication>
#include <QQmlApplicationEngine>

class WorkingDirectory : public QObject {
	Q_OBJECT

	public:
		Q_INVOKABLE bool cd(const QString& path) const {
			QDir current(QDir::current());

			const bool result = current.cd(path);

			QDir::setCurrent(current.absolutePath());

			return result;
		}

		Q_INVOKABLE QString current() const {
			return QDir::current().absolutePath();
		}
};

int main(int argc, char *argv[]) {
	WorkingDirectory      directory;
	QApplication          application(argc, argv);
	QQmlApplicationEngine engine(QUrl(QStringLiteral("qrc:/main.qml")));

	application.setOrganizationName("akr");
	application.setApplicationName("MetaTerm");

	engine.rootContext()->setContextProperty("workingDirectory", &directory);

	QObject::connect(
		static_cast<QObject*>(&engine),
		SIGNAL(quit()),
		static_cast<QObject*>(&application),
		SLOT(quit())
	);

	return application.exec();
}

#include "main.moc"
