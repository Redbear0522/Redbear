package board;

import java.sql.*;
import java.util.*;


public class PostDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private PostDTO pd;
		
	private static PostDAO instance = new PostDAO();
	
	public static PostDAO getInstance() {
		return instance;
	
	}
	private PostDAO() {}
	
    private Connection connect() {
		try {
			//1단계
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			//2단계
			//String url = "jdbc:oracle:thin:@192.168.219.198:1521:orcl";
			String url = "jdbc:oracle:thin:@58.73.200.225:1521:orcl";
			conn = DriverManager.getConnection(url, "java03", "1234");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}

    private void disconnect() {
        try {
            if (rs != null && !rs.isClosed()) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (pstmt != null && !pstmt.isClosed()) pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 1. 글 등록
    public int insertPost(PostDTO pd) {
        int result = 0;
        int num = pd.getNum();
        // 이 변수들은 답글 처리 시에만 사용됩니다.
        int ref = pd.getRef();
        int re_step = pd.getRe_step();
        int re_level = pd.getRe_level();
        
        int number = 0;
        String sql = "";

        try {
            connect();
            // 새 글의 ref 그룹 번호를 정하기 위해 현재 최대 글 번호를 가져옴
            sql = "select max(num) from post";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                number = rs.getInt(1) + 1;
            } else {
                number = 1;
            }

            // 답글인 경우 (원글의 정보가 넘어온 경우)
            if (num != 0) {
                // 같은 그룹 내에서 기존 답글들의 순서를 1씩 뒤로 민다.
                sql = "update post set re_step=re_step+1 where ref=? and re_step > ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, ref);
                pstmt.setInt(2, re_step);
                pstmt.executeUpdate();

                // 새로 추가될 답글의 순서와 깊이를 1씩 증가시킨다.
                re_step = re_step + 1;
                re_level = re_level + 1;
            
            } else { // 새 글인 경우
                ref = number;  // 그룹 번호(ref)는 자신의 글 번호(number)와 동일하게
                re_step = 0;   // 순서(re_step)는 0
                re_level = 0;  // 깊이(re_level)는 0
            }
            
            // regdate와 readcnt는 DB에서 직접 처리하도록 SQL 수정
            sql = "insert into post(num, writer, title, content, pw, regdate, readcnt, ip, ref, re_step, re_level) "
                + "values(post_sq.nextval, ?, ?, ?, ?, sysdate, 0, ?, ?, ?, ?)";

            // ★★★ PreparedStatement 객체 재할당 ★★★
            pstmt = conn.prepareStatement(sql);

            // ★★★ 파라미터 인덱스와 변수 사용 수정 ★★★
            pstmt.setString(1, pd.getWriter());
            pstmt.setString(2, pd.getTitle());
            pstmt.setString(3, pd.getContent()); // title 중복 설정 수정
            pstmt.setString(4, pd.getPw());
            pstmt.setString(5, pd.getIp());
            pstmt.setInt(6, ref);       // 계산된 지역 변수 ref 사용
            pstmt.setInt(7, re_step);   // 계산된 지역 변수 re_step 사용
            pstmt.setInt(8, re_level);  // 계산된 지역 변수 re_level 사용

            // ★★★ executeUpdate는 한 번만 호출 ★★★
            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return result; // result 값 반환
    }

    // 2. 글 목록
    public List<PostDTO> getPostList(int start, int end) {
        List<PostDTO> list = new ArrayList<>();
        String sql = "select num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt,r "
    			+ "from (select num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt,rownum r "
    			+ "from (select num,writer,title,pw,regdate,ref,re_step,re_level,content,ip,readcnt "
    			+ "from post order by ref desc, re_step asc)) where r >= ? and r <= ?";
        try {
            connect();
            pstmt = conn.prepareStatement(sql);
    		pstmt.setInt(1, start);
    		pstmt.setInt(2, end);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setPw(rs.getString("pw"));
                // [수정] rs.getString("regdate") -> rs.getTimestamp("regdate")
                // PostDTO의 regdate 필드는 Timestamp 타입이므로 getTimestamp()로 받아야 합니다.
                dto.setRegdate(rs.getTimestamp("regdate")); 
                dto.setReadcnt(rs.getInt("readcnt"));
                dto.setRef(rs.getInt("ref"));
                dto.setRe_step(rs.getInt("re_step"));
    			dto.setRe_level(rs.getInt("re_level"));
    			dto.setContent(rs.getString("content"));
    			dto.setIp(rs.getString("ip"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return list;
    }

    // 3. 글 보기
 // Redbear/src/main/java/board/PostDAO.java

    public PostDTO getPost(int num) {
        PostDTO dto = null;
        String updateSql = "UPDATE post SET readcnt = readcnt + 1 WHERE num = ?";
        String selectSql = "SELECT * FROM post WHERE num = ?";
        try {
            connect();
            // [개선 제안] 글 내용을 가져올 때 조회수를 증가시키는 로직을 함께 처리하면 더 효율적입니다.
            increaseReadcnt(num); // 이 메소드를 여기서 호출하고,
            
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, num);
            pstmt.executeUpdate();
            
            if (pstmt != null) pstmt.close();
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, num);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new PostDTO();
                dto.setNum(rs.getInt("num"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                // [수정] rs.getString("regdate") -> rs.getTimestamp("regdate")
                dto.setRegdate(rs.getTimestamp("regdate"));
                dto.setReadcnt(rs.getInt("readcnt"));
                // [개선 제안] 게시글 수정/삭제 시 비밀번호 확인 또는 답글 기능을 위해 추가 정보를 가져오는 것이 좋습니다.
                 dto.setPw(rs.getString("pw"));
                 dto.setRef(rs.getInt("ref"));
                 dto.setRe_step(rs.getInt("re_step"));
                 dto.setRe_level(rs.getInt("re_level"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return dto;
    }

    // 4. 조회수 증가
    public void increaseReadcnt(int num) {
        
    }

    // 5. 글 수정
    public int updatePost(PostDTO dto) {
        int res = 0;
        String sql = "UPDATE post SET title = ?, content = ? WHERE num = ? AND pw = ?";
        try {
            connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setInt(3, dto.getNum());
            pstmt.setString(4, dto.getPw());
            res = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }

    // 6. 글 삭제
    public int deletePost(int num, String pw) {
        int res = 0;
        String sql = "DELETE FROM post WHERE num = ? AND pw = ?";
        try {
            connect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, num);
            pstmt.setString(2, pw);
            res = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            disconnect();
        }
        return res;
    }
    
    public int getArticleCount() {
		
		int x = 0;
		try {
			conn=connect();
			pstmt = conn.prepareStatement("select count(*) from post");
			rs = pstmt.executeQuery();
			if (rs.next()) {
				x = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			disconnect();
		}
		return x;
	}
}
