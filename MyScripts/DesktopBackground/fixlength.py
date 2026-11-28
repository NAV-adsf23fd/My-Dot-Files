import sys

def nhan_doi_ky_tu_truoc(art, buoc_nhay=3, so_lan_lap=1):
    cac_dong = art.splitlines()
    ket_qua = []
    
    for dong in cac_dong:
        cum_ky_tu = [dong[i:i + buoc_nhay] for i in range(0, len(dong), buoc_nhay)]
        dong_moi = ""
        
        for index, cum in enumerate(cum_ky_tu):
            if index < len(cum_ky_tu) - 1:
                dong_moi += cum + (cum[-1] * so_lan_lap)
            else:
                dong_moi += cum
                
        ket_qua.append(dong_moi)
        
    return "\n".join(ket_qua)

def main():
    if len(sys.argv) < 3:
        print("Cach dung: python script.py <file_dau_vao> <file_dau_ra>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    try:
        with open(input_file, "r", encoding="utf-8") as f:
            noi_dung = f.read()

        ket_qua = nhan_doi_ky_tu_truoc(noi_dung)

        with open(output_file, "w", encoding="utf-8") as f:
            f.write(ket_qua)

        print(f"Da xu ly xong! Ket qua duoc luu tai: {output_file}")

    except FileNotFoundError:
        print(f"Loi: Khong tim thay file '{input_file}'")
    except Exception as e:
        print(f"Co loi xay ra: {e}")

if __name__ == "__main__":
    main()
