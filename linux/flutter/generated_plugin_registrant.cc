//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <ble_peripheral/ble_peripheral_plugin.h>
#include <dynamic_color/dynamic_color_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) ble_peripheral_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BlePeripheralPlugin");
  ble_peripheral_plugin_register_with_registrar(ble_peripheral_registrar);
  g_autoptr(FlPluginRegistrar) dynamic_color_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DynamicColorPlugin");
  dynamic_color_plugin_register_with_registrar(dynamic_color_registrar);
}
