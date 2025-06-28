# UART APB Controller

Dự án này hiện thực bộ điều khiển UART với giao tiếp APB, bao gồm các module:
- **src/**: Chứa mã nguồn Verilog cho các thành phần của UART APB Controller.
- **test/** hoặc **tb/**: Chứa testbenches để kiểm tra chức năng các module.
- **doc/**: Tài liệu hướng dẫn, mô tả thiết kế, sơ đồ, v.v.

## Cấu trúc thư mục

```
UART_APB_controller/
├── src/         # Mã nguồn Verilog
├── tb/          # Testbenches
├── doc/         # Tài liệu
└── README.md    # File mô tả này
```

## Hướng dẫn sử dụng

1. **Mở mã nguồn** trong thư mục `src/`.
2. **Chạy testbench** trong thư mục `test/` hoặc `tb/` bằng phần mềm mô phỏng (ModelSim, Icarus Verilog, v.v.).
3. **Xem tài liệu** trong `doc/` để biết chi tiết kỹ thuật.

## Yêu cầu

- Verilog/SystemVerilog Compiler (Icarus Verilog, ModelSim, Vivado, ...)
- Kiến thức cơ bản về giao tiếp UART và bus APB (AMBA)

## Đóng góp

Pull request và issue luôn được hoan nghênh!
