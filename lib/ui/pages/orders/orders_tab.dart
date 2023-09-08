import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:grocery/ui/pages/orders/controller/all_orders_controller.dart';
import '../../../app_colors.dart';
import 'components/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pedidos', style: TextStyle(color: Colors.white),),
      ),
      body: GetBuilder<AllOrdersController>(builder: (controller) {

        if (controller.allOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 40,
                  color: CustomColors.customSwatchColor,
                ),
                const Text('Sem pedidos recentes.'),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemBuilder: (_, index) => OrderTile(order: controller.allOrders[index]),
          itemCount: controller.allOrders.length,
        );
      }),
    );
  }
}
