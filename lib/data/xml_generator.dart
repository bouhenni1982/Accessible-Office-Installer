import 'package:xml/xml.dart';
import '../domain/models.dart';

class XmlGenerator {
  static String generate(OfficeConfig config) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Configuration', nest: () {
      builder.element('Add', attributes: {
        'OfficeClientEdition': config.architecture,
        'Channel': config.channel,
        if (config.forceDowngrade) 'ForceDowngrade': 'True',
      }, nest: () {
        builder.element('Product', attributes: {'ID': config.edition}, nest: () {
          builder.element('Language', attributes: {'ID': config.language});
          
          for (final app in config.excludeApps) {
            builder.element('ExcludeApp', attributes: {'ID': app});
          }
        });
      });

      builder.element('Display', attributes: {
        'Level': config.displayLevel,
        'AcceptEULA': config.acceptEula ? 'TRUE' : 'FALSE',
      });

      // Remove legacy MSI-based Office installs that commonly block Click-to-Run.
      builder.element('RemoveMSI');

      if (config.autoActivate) {
        builder.element('Property', attributes: {
          'Name': 'AUTOACTIVATE',
          'Value': '1',
        });
      }
      
      builder.element('Property', attributes: {
        'Name': 'FORCEAPPSHUTDOWN',
        'Value': 'TRUE',
      });
      builder.element('Property', attributes: {
        'Name': 'SharedComputerLicensing',
        'Value': '0',
      });
      builder.element('Property', attributes: {
        'Name': 'PinIconsToTaskbar',
        'Value': 'TRUE',
      });
    });

    final document = builder.buildDocument();
    return document.toXmlString(pretty: true, indent: '  ');
  }
}
