package board;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class GalleryDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    private static GalleryDAO instance = new GalleryDAO();
    public static GalleryDAO getInstance() {
        return instance;
    }
    private GalleryDAO() {}

    // GallerygreSQL 연결 메서드
    private Connection connect() {
        try {
            Class.forName("org.postgresql.Driver");
            String url  ="postgresql://redbearstorage_02d4_user:6cgrFSNQY4fcoNmX2Zm7kheOPqEZKnvq@dpg-d24nbuali9vc73eftdkg-a.singapore-postgres.render.com/redbearstorage_02d4";
	        String user = "redbearstorage_02d4_user";
	        String pass = "6cgrFSNQY4fcoNmX2Zm7kheOPqEZKnvq";
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 리소스 해제
    private void disconnect() {
        try { if (rs    != null) rs.close();    } catch (SQLException ignored) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException ignored) {}
        try { if (conn  != null) conn.close();  } catch (SQLException ignored) {}
    }

    /** 조회수 증가 */
    public void setReadCountUpdate(int num) {
        String sql = "UPDATE public.gallery SET readcnt = COALESCE(readcnt, 0) + 1 WHERE num = ?";
        try {
            conn = connect();
            if (conn == null) {
                System.out.println("데이터베이스 연결 실패");
                return;
            }
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            int result = pstmt.executeUpdate();
            System.out.println("조회수 업데이트 결과: " + result + " 행이 수정됨");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
    }

    /** 1. 글 등록 */
    public int insertGallery(GalleryDTO pd) {
        int result = 0;
        int num      = pd.getNum();
        int ref      = pd.getRef();
        int re_step  = pd.getRe_step();
        int re_level = pd.getRe_level();
        int number   = 0;

        try {
            conn = connect();
            // 최대 num 조회
            String maxSql = "SELECT COALESCE(MAX(num),0) FROM public.gallery";
            pstmt = conn.prepareStatement(maxSql);
            rs = pstmt.executeQuery();
            if (rs.next()) number = rs.getInt(1) + 1;
            rs.close(); pstmt.close();

            // 답글 처리
            if (num != 0) {
                String uSql = "UPDATE public.gallery SET re_step = re_step + 1 WHERE ref = ? AND re_step > ?";
                pstmt = conn.prepareStatement(uSql);
                pstmt.setInt(1, ref);
                pstmt.setInt(2, re_step);
                pstmt.executeUpdate();
                pstmt.close();
                re_step++; re_level++;
            } else {
                ref = number; re_step = 0; re_level = 0;
            }

            // INSERT: regdate, readcnt는 테이블 기본값 사용, 컬럼에서 제거
            String iSql =
            	     "INSERT INTO public.gallery(" +
            	     " num,writer,title,content,pw,ip,ref,re_step,re_level,image" +
            	     ") VALUES (" +
            	     " nextval('gallery_sq'), ?,?,?,?,?,?,?,?,?" +
            	     ")";
            pstmt = conn.prepareStatement(iSql);
            pstmt.setString(1, pd.getWriter());
            pstmt.setString(2, pd.getTitle());
            pstmt.setString(3, pd.getContent());
            pstmt.setString(4, pd.getPw());
            pstmt.setString(5, pd.getIp());
            pstmt.setInt   (6, ref);
            pstmt.setInt   (7, re_step);
            pstmt.setInt   (8, re_level);
            pstmt.setString(9, pd.getImage()); 
            
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result;
    }

    /** 2. 글 목록 (페이징) */
    public List<GalleryDTO> getGalleryList(int start, int end) {
        List<GalleryDTO> list = new ArrayList<>();
        int limit  = end - start + 1;
        int offset = start - 1;
        String sql =
        		"SELECT num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt,image " +
        		"FROM public.gallery " +
            "ORDER BY ref DESC,re_step ASC " +
            "LIMIT ? OFFSET ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                GalleryDTO dto = new GalleryDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setPw(rs.getString("pw"));
                dto.setRegdate(rs.getDate("regdate").toString());
                dto.setReadcnt(rs.getInt("readcnt"));
                dto.setImage   (rs.getString("image")); 
                dto.setRef(rs.getInt("ref"));
                dto.setRe_step(rs.getInt("re_step"));
                dto.setRe_level(rs.getInt("re_level"));
                dto.setContent(rs.getString("content"));
                dto.setIp(rs.getString("ip"));
                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    /** 3. 글 보기 */
    public GalleryDTO getGallery(int num) {
        GalleryDTO dto = null;
        String sql = "SELECT * FROM public.gallery WHERE num = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new GalleryDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setRegdate(rs.getDate("regdate").toString());
                dto.setReadcnt(rs.getInt("readcnt"));
                dto.setImage   (rs.getString("image"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    /** 조회수 증가 */
public void updateReadCount(int num) {
    try {
        conn = connect();
        pstmt = conn.prepareStatement(
            "UPDATE public.gallery SET readcnt = COALESCE(readcnt, 0) + 1 WHERE num = ?"
        );
        pstmt.setInt(1, num);
        pstmt.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        disconnect();
    }
}

    /** 글 수정 */
public int updateGallery(GalleryDTO dto) {
    int result = 0;
    
    try {
        conn = connect();
        
        // 1. 게시물 존재 여부와 비밀번호 확인
        pstmt = conn.prepareStatement(
            "SELECT pw, writer FROM gallery WHERE num = ?"
        );
        pstmt.setInt(1, dto.getNum());
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String dbpasswd = rs.getString("pw");
            
            // 비밀번호 확인
            if (dbpasswd.equals(dto.getPw())) {
                String updateQuery;
                if (dto.getImage() != null && !dto.getImage().trim().isEmpty()) {
                    updateQuery = "UPDATE gallery SET title=?, content=?, image=?, moddate=CURRENT_TIMESTAMP "
                              + "WHERE num=?";
                } else {
                    updateQuery = "UPDATE gallery SET title=?, content=?, moddate=CURRENT_TIMESTAMP "
                              + "WHERE num=?";
                }
                
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setString(1, dto.getTitle());
                pstmt.setString(2, dto.getContent());
                
                if (dto.getImage() != null && !dto.getImage().trim().isEmpty()) {
                    pstmt.setString(3, dto.getImage());
                    pstmt.setInt(4, dto.getNum());
                } else {
                    pstmt.setInt(3, dto.getNum());
                }
                
                result = pstmt.executeUpdate();
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        disconnect();
    }
    return result;
}

    /** 6. 글 삭제 */
    public int deleteGallery(int num, String pw) {
        int res = 0;
        String sql = "DELETE FROM Gallery WHERE num = ? AND pw = ?";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.setString(2, pw);
            res = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }

    /** 7. 전체 글 개수 */
    public int getArticleCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Gallery";
        try {
            conn = connect();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return count;
    }
}
