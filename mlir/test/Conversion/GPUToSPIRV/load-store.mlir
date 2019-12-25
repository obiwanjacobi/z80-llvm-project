// RUN: mlir-opt -convert-gpu-to-spirv %s -o - | FileCheck %s

module attributes {gpu.container_module} {
  func @load_store(%arg0: memref<12x4xf32>, %arg1: memref<12x4xf32>, %arg2: memref<12x4xf32>) {
    %c0 = constant 0 : index
    %c12 = constant 12 : index
    %0 = subi %c12, %c0 : index
    %c1 = constant 1 : index
    %c0_0 = constant 0 : index
    %c4 = constant 4 : index
    %1 = subi %c4, %c0_0 : index
    %c1_1 = constant 1 : index
    %c1_2 = constant 1 : index
    "gpu.launch_func"(%0, %c1_2, %c1_2, %1, %c1_2, %c1_2, %arg0, %arg1, %arg2, %c0, %c0_0, %c1, %c1_1) {kernel = "load_store_kernel", kernel_module = @kernels} : (index, index, index, index, index, index, memref<12x4xf32>, memref<12x4xf32>, memref<12x4xf32>, index, index, index, index) -> ()
    return
  }

  // CHECK-LABEL: spv.module "Logical" "GLSL450"
  module @kernels attributes {gpu.kernel_module} {
    // CHECK-DAG: spv.globalVariable [[WORKGROUPSIZEVAR:@.*]] built_in("WorkgroupSize") : !spv.ptr<vector<3xi32>, Input>
    // CHECK-DAG: spv.globalVariable [[NUMWORKGROUPSVAR:@.*]] built_in("NumWorkgroups") : !spv.ptr<vector<3xi32>, Input>
    // CHECK-DAG: spv.globalVariable [[LOCALINVOCATIONIDVAR:@.*]] built_in("LocalInvocationId") : !spv.ptr<vector<3xi32>, Input>
    // CHECK-DAG: spv.globalVariable [[WORKGROUPIDVAR:@.*]] built_in("WorkgroupId") : !spv.ptr<vector<3xi32>, Input>
    // CHECK-LABEL:    func @load_store_kernel
    // CHECK-SAME: [[ARG0:%.*]]: !spv.ptr<!spv.struct<!spv.array<48 x f32 [4]> [0]>, StorageBuffer> {spirv.interface_var_abi = {binding = 0 : i32, descriptor_set = 0 : i32, storage_class = 12 : i32{{[}][}]}}
    // CHECK-SAME: [[ARG1:%.*]]: !spv.ptr<!spv.struct<!spv.array<48 x f32 [4]> [0]>, StorageBuffer> {spirv.interface_var_abi = {binding = 1 : i32, descriptor_set = 0 : i32, storage_class = 12 : i32{{[}][}]}}
    // CHECK-SAME: [[ARG2:%.*]]: !spv.ptr<!spv.struct<!spv.array<48 x f32 [4]> [0]>, StorageBuffer> {spirv.interface_var_abi = {binding = 2 : i32, descriptor_set = 0 : i32, storage_class = 12 : i32{{[}][}]}}
    // CHECK-SAME: [[ARG3:%.*]]: i32 {spirv.interface_var_abi = {binding = 3 : i32, descriptor_set = 0 : i32, storage_class = 12 : i32{{[}][}]}}
    // CHECK-SAME: [[ARG4:%.*]]: i32 {spirv.interface_var_abi = {binding = 4 : i32, descriptor_set = 0 : i32, storage_class = 12 : i32{{[}][}]}}
    // CHECK-SAME: [[ARG5:%.*]]: i32 {spirv.interface_var_abi = {binding = 5 : i32, descriptor_set = 0 : i32, storage_class = 12 : i32{{[}][}]}}
    // CHECK-SAME: [[ARG6:%.*]]: i32 {spirv.interface_var_abi = {binding = 6 : i32, descriptor_set = 0 : i32, storage_class = 12 : i32{{[}][}]}}
    gpu.func @load_store_kernel(%arg0: memref<12x4xf32>, %arg1: memref<12x4xf32>, %arg2: memref<12x4xf32>, %arg3: index, %arg4: index, %arg5: index, %arg6: index)
      attributes  {gpu.kernel} {
      // CHECK: [[ADDRESSWORKGROUPID:%.*]] = spv._address_of [[WORKGROUPIDVAR]]
      // CHECK: [[WORKGROUPID:%.*]] = spv.Load "Input" [[ADDRESSWORKGROUPID]]
      // CHECK: [[WORKGROUPIDX:%.*]] = spv.CompositeExtract [[WORKGROUPID]]{{\[}}0 : i32{{\]}}
      // CHECK: [[ADDRESSLOCALINVOCATIONID:%.*]] = spv._address_of [[LOCALINVOCATIONIDVAR]]
      // CHECK: [[LOCALINVOCATIONID:%.*]] = spv.Load "Input" [[ADDRESSLOCALINVOCATIONID]]
      // CHECK: [[LOCALINVOCATIONIDX:%.*]] = spv.CompositeExtract [[LOCALINVOCATIONID]]{{\[}}0 : i32{{\]}}
      %0 = "gpu.block_id"() {dimension = "x"} : () -> index
      %1 = "gpu.block_id"() {dimension = "y"} : () -> index
      %2 = "gpu.block_id"() {dimension = "z"} : () -> index
      %3 = "gpu.thread_id"() {dimension = "x"} : () -> index
      %4 = "gpu.thread_id"() {dimension = "y"} : () -> index
      %5 = "gpu.thread_id"() {dimension = "z"} : () -> index
      %6 = "gpu.grid_dim"() {dimension = "x"} : () -> index
      %7 = "gpu.grid_dim"() {dimension = "y"} : () -> index
      %8 = "gpu.grid_dim"() {dimension = "z"} : () -> index
      %9 = "gpu.block_dim"() {dimension = "x"} : () -> index
      %10 = "gpu.block_dim"() {dimension = "y"} : () -> index
      %11 = "gpu.block_dim"() {dimension = "z"} : () -> index
      // CHECK: [[INDEX1:%.*]] = spv.IAdd [[ARG3]], [[WORKGROUPIDX]]
      %12 = addi %arg3, %0 : index
      // CHECK: [[INDEX2:%.*]] = spv.IAdd [[ARG4]], [[LOCALINVOCATIONIDX]]
      %13 = addi %arg4, %3 : index
      // CHECK: [[STRIDE1_1:%.*]] = spv.constant 4 : i32
      // CHECK: [[OFFSET1_1:%.*]] = spv.IMul [[STRIDE1_1]], [[INDEX1]] : i32
      // CHECK: [[STRIDE1_2:%.*]] = spv.constant 1 : i32
      // CHECK: [[UPDATE1_2:%.*]] = spv.IMul [[STRIDE1_2]], [[INDEX2]] : i32
      // CHECK: [[OFFSET1_2:%.*]] = spv.IAdd [[OFFSET1_1]], [[UPDATE1_2]] : i32
      // CHECK: [[ZERO1:%.*]] = spv.constant 0 : i32
      // CHECK: [[PTR1:%.*]] = spv.AccessChain [[ARG0]]{{\[}}[[ZERO1]], [[OFFSET1_2]]{{\]}}
      // CHECK-NEXT: [[VAL1:%.*]] = spv.Load "StorageBuffer" [[PTR1]]
      %14 = load %arg0[%12, %13] : memref<12x4xf32>
      // CHECK: [[PTR2:%.*]] = spv.AccessChain [[ARG1]]{{\[}}{{%.*}}, {{%.*}}{{\]}}
      // CHECK-NEXT: [[VAL2:%.*]] = spv.Load "StorageBuffer" [[PTR2]]
      %15 = load %arg1[%12, %13] : memref<12x4xf32>
      // CHECK: [[VAL3:%.*]] = spv.FAdd [[VAL1]], [[VAL2]]
      %16 = addf %14, %15 : f32
      // CHECK: [[PTR3:%.*]] = spv.AccessChain [[ARG2]]{{\[}}{{%.*}}, {{%.*}}{{\]}}
      // CHECK-NEXT: spv.Store "StorageBuffer" [[PTR3]], [[VAL3]]
      store %16, %arg2[%12, %13] : memref<12x4xf32>
      gpu.return
    }
  }
}
